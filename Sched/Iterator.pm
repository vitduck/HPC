package HPC::Sched::Iterator; 

use Moose; 
use MooseX::Attribute::Chained; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw(Str ArrayRef); 
use Set::CrossProduct; 
use feature 'signatures';  
no warnings 'experimental::signatures'; 

has dir => ( 
    is      => 'rw', 
    isa     => Str, 
    lazy    => 1, 
    default => 'nested'
);  

has iterator => ( 
    is       => 'rw', 
    isa      => ArrayRef,  
    traits   => ['Array'],
    handles  => { list_iterator => 'elements'}
); 

around BUILDARGS => sub ($method, $class, $ref) {
    my ($scan, $set, $cross, $iterator); 

    # @scan: ordered of set 
    # %set:  for Set::CrosspProduct
    while ( my ($atr, $val) = splice $ref->@*, 0, 2 ) { 
        $set->{$atr} = $val;  
        push $scan->@*, $atr; 
    }

    # iterator: ArrayRef[HashRef]
    if ( keys $set->%* == 1 ) { 
        my ($atr, $val) = $set->%*;  
        $cross = [map { {$atr => $_} } $val->@*]; 
    } else { 
        $cross = Set::CrossProduct->new($set)
                                  ->combinations
    } 
   
    # convert HashRef to ordered ArrayRef 
    for my $product ($cross->@*) { 
        my @orders; 

        for my $atr ($scan->@*) { 
            push @orders, [$atr, $product->{$atr}]
        }

        push $iterator->@*, [@orders]
    } 

    $class->$method( iterator => $iterator )
};  

# default  => sub {{ 
        # job        => [qw(select ncpus ngpus mpiprocs omp)],
        # numa       => [qw(membind preferred)],
        # mpi        => [qw(pin eagersize)], 
        # vasp       => [qw(ncore nsim kpar npar)], 
        # qe         => [qw(nimage npools nband ntg ndiag)], 
        # gromacs    => [qw(dorder npme nt ntmpi ntomp)],  
        # tensorflow => [qw(num_inter_threads num_intra_threads)]}}, 

# has 'iterator' => ( 
    # is       => 'ro', 
    # isa      => ArrayRef, 
    # init_arg => undef, 
    # traits   => ['Array'],
    # predicate => '_has_iterator',
    # lazy     => 1, 
    # default  => sub {[]}, 
    # handles  => { 
        # _add_iterator  => 'push', 
        # _list_iterator => 'elements'
    # } 
# ); 

# sub iterate($self, $param, $structure='nested') { 
    # my $iterator = Set::CrossProduct->new($param); 

    # p $iterator->combinations; 
# } 

# sub iterate($self, $scan_list, $structure='nested') { 
    # my @chains;  
    # my @iterators = ([]);

    # # flatten the list
    # while (my ($key, $val) = splice $scan_list->@*, 0, 2) { 
        # @chains    = $self->_make_chain($key, $val); 
        # @iterators = $self->_join_chain(\@iterators, \@chains); 
    # } 

    # for my $chain (@iterators) { 
        # my ($dir, $root_dir); 
        # my (@links, @cmds); 
        
        # for my $link ( $chain->@* ) { 
            # push @links, $self->_set_link($link, $structure)
        # } 
        
        # # join fragment to form full path
        # if ( $structure eq 'flat' ) { 
            # $dir      = join('-', @links); 
            # $root_dir = '../'; 
        # } else { 
            # $dir      = join('/',@links); 
            # $root_dir = join('/', map '..', 0..@links-1); 
        # }

        # # add to iterator list
        # $self->_add_iterator($dir); 

        # # plugin's commands 
        # $self->reset_cmd; 

        # # mkdir sub directories 
        # $self->mkdir($dir);  

        # # copy VASP input
        # if ($self->_has_vasp) { 
            # my $template = $self->vasp->template; 
            # $self->copy("$template/{INCAR,KPOINTS,POSCAR,POTCAR}" => $dir) if $template; 
        # }

        # $self->chdir($dir) 
             # ->add([
                # $self->mpirun, 
                # map $self->$_->cmd, $self->_list_plugin]) 
             # ->write('run.sh')
             # ->chdir($root_dir)
    # }

    # return $self
# }

# sub _set_link ($self, $link, $structure='nested') { 
    # my $mpi; 
    # my @sub_dirs; 

    # while (my ($setter, $value) = splice $link->@*, 0, 2) { 
        # for my $param ($self->_list_param) { 
            # if ( grep $setter eq $_,  $self->_get_param($param)->@* ) { 
                # # pbs/slm
                # if ($param eq 'job') { 
                    # $self->$setter($value) 
                # # mpi 
                # } elsif ($param eq 'mpi') { 
                    # $mpi = $self->_get_mpi; 
                    # $self->$mpi->$setter($value) ; 
                    # # enable binding while scanning
                    # $self->$mpi->debug(4) if $setter eq 'pin'
                # # app
                # } else  { 
                    # $self->$param->$setter($value) 
                # } 
            # } 
        # }
        # push @sub_dirs, 
            # $structure eq 'flat' 
                # ? uc(substr($setter, 0, 1)).$value
                # : join('_', $setter, $value)
    # } 

    # return join('-', @sub_dirs)
# } 

# sub _make_chain ($self, $key, $val) {
    # my @chains; 

    # my @attrs = split /\//, $key;
    # my @vals  = map [ split /\//, $_ ], $val->@*;

    # for my $i (0..$#vals) {
        # my @links;

        # for my $j (0..$#attrs) {
            # push @links, $attrs[$j], $vals[$i][$j]
        # }

        # push @chains, [ @links ]
    # }

    # return @chains 
# }

# sub _join_chain ($self, $c1, $c2) { 
    # my @join_chains; 

    # for my $i (0 .. $c1->$#*) {
        # for my $j (0 .. $c2->$#*) {
            # # use dclone for deep copy
            # my @chains = dclone($c1->[$i])->@*;

            # push @chains, dclone($c2->[$j]);
            # push @join_chains, [ @chains ]
        # }
    # }

    # return @join_chains 
# }

__PACKAGE__->meta->make_immutable;

1
