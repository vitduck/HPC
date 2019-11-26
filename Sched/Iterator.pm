package HPC::Sched::Iterator; 

use Moose::Role; 
use File::Basename;
use File::Spec;
use List::Util 'first'; 
use Storable 'dclone';

use feature 'signatures';  
no warnings 'experimental::signatures'; 

my %lookup = ( 
    job  => ['select', 'mpiprocs', 'omp'], 
    mpi  => ['pin', 'eager'], 
    vasp => ['ncore', 'nsim', 'kpar', 'npar']
); 

sub iterate($self, $scan_list) { 
    my @lists;  
    my @iterators = ([]);

    # flatten the list
    while (my ($key, $val) = splice $scan_list->@*, 0, 2) { 
        @lists     = $self->_distribute_list($key, $val); 
        @iterators = $self->_merge_list(\@iterators, \@lists); 
    } 

    for (@iterators) { 
        my ($dir, $root_dir); 
        my @dirs; 
        
        for ( $_->@* ) { 
            my @sub_dirs; 

            while (my ($key, $value) = splice $_->@*, 0, 2) { 
                my $plugin;  

                # check method tables; 
                for (keys %lookup) { 
                    if ( first { $_ eq $key } $lookup{$_}->@* ) {  
                        $plugin = $_
                    }
                } 

                if    ($plugin eq 'job') { $self->$key($value) }
                elsif ($plugin eq 'mpi') { my $mpi = $self->_get_mpi; $self->$mpi->$key($value) } 
                else                     { $self->$plugin->$key($value) } 

                push @sub_dirs, join('_', $key, $value)
            } 
            push @dirs, join('-', @sub_dirs)
        } 
        
        # join fragment to form full path
        $dir      = join('/',@dirs); 
        $root_dir = join('/', map '..', 0..@dirs-1); 

        $self->mkdir($dir) 
             ->chdir($dir) 
             ->cmd([])
             ->add($self->mpirun)
             ->write('run.sh')
             ->chdir($root_dir)
    }
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
