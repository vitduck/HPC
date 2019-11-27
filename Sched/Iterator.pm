package HPC::Sched::Iterator; 

use Moose::Role; 
use MooseX::Types::Moose qw(HashRef ArrayRef); 
use File::Basename;
use File::Spec;
use List::Util 'first'; 
use Storable 'dclone';

use feature 'signatures';  
no warnings 'experimental::signatures'; 

has params => ( 
    is       => 'ro', 
    isa      => HashRef, 
    init_arg => undef, 
    traits   => ['Hash'],
    default  => sub {{ 
        job        => [qw(select ncpus gpus mpiprocs omp)],
        numa       => [qw(membind preferred)],
        mpi        => [qw(pin eagersize)], 
        vasp       => [qw(ncore nsim kpar npar)], 
        qe         => [qw(nimage npools nband ntg ndiag)], 
        gromacs    => [qw(dorder npme nt ntmpi ntomp)],  
        tensorflow => [qw(num_inter_threads num_intra_threads)]}}, 
    handles  => {
        _get_param  => 'get', 
        _list_param => 'keys'}
); 

has 'iterator' => ( 
    is       => 'ro', 
    isa      => ArrayRef, 
    init_arg => undef, 
    traits   => ['Array'],
    predicate => '_has_iterator',
    lazy     => 1, 
    default  => sub {[]}, 
    handles  => { 
        _add_iterator  => 'push', 
        _list_iterator => 'elements'
    } 
); 

sub iterate($self, $scan_list) { 
    my @lists;  
    my @iterators = ([]);

    # flatten the list
    while (my ($key, $val) = splice $scan_list->@*, 0, 2) { 
        @lists     = $self->_distribute_list($key, $val); 
        @iterators = $self->_merge_list(\@iterators, \@lists); 
    } 

    for my $chain (@iterators) { 
        my ($dir, $root_dir); 
        my (@links, @cmds); 
        
        for my $link ( $chain->@* ) { 
            push @links, $self->_set_link($link)
        } 
        
        # join fragment to form full path
        $dir      = join('/',@links); 
        $root_dir = join('/', map '..', 0..@links-1); 

        # add to iterator list
        $self->_add_iterator($dir); 

        # plugin's commands 
        $self->reset_cmd; 

        # mkdir sub directories 
        $self->mkdir($dir);  

        # copy VASP input
        if ($self->_has_vasp) { 
            my $template = $self->vasp->template; 
            $self->copy("$template/{INCAR,KPOINTS,POSCAR,POTCAR}" => $dir)
        }

        $self->chdir($dir) 
             ->add([
                $self->mpirun, 
                map $self->$_->cmd, $self->_list_plugin]) 
             ->write('run.sh')
             ->chdir($root_dir)
    }

    return $self
}

sub _set_link ($self, $link) { 
    my $mpi; 
    my @sub_dirs; 

    while (my ($setter, $value) = splice $link->@*, 0, 2) { 
        for my $param ($self->_list_param) { 
            if ( grep $setter eq $_,  $self->_get_param($param)->@* ) { 
                # pbs/slm
                if ($param eq 'job') { 
                    $self->$setter($value) 
                # mpi 
                } elsif ($param eq 'mpi') { 
                    $mpi = $self->_get_mpi; 
                    $self->$mpi->$setter($value) ; 
                    # show binding while scanning
                    $self->$mpi->debug(4)
                # app
                } else  { 
                    $self->$param->$setter($value) 
                } 
            } 
        }
        push @sub_dirs, join('_', $setter, $value)
    } 

    return join('-', @sub_dirs)
} 

sub _distribute_list ($self, $key, $val) {
    my @dists;

    my @attrs = split /\//, $key;
    my @vals  = map [ split /\//, $_ ], $val->@*;

    for my $i (0..$#vals) {
        my @chains;
        for my $j (0..$#attrs) {
            push @chains, $attrs[$j], $vals[$i][$j]
        }
        push @dists, [@chains]
    }

    return @dists
}

sub _merge_list ($self, $l1, $l2) { 
    my @merged;

    for my $i (0 .. $l1->$#*) {
        for my $j (0 .. $l2->$#*) {
            # use dclone for deep copy
            my @chains = dclone($l1->[$i])->@*;
            push @chains, dclone($l2->[$j]);
            push @merged, [@chains]
        }
    }

    return @merged
}

1
