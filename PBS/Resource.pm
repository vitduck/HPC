package HPC::PBS::Resource; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 
use HPC::PBS::Types::PBS qw(Shell Export Project Account Queue Name Resource Walltime Stdout Stderr); 

has 'shell' => ( 
    is        => 'rw', 
    isa       =>  Shell,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_shell',
    default   => 'bash'
); 

has 'export' => ( 
    is        => 'ro', 
    isa       =>  Export,
    coerce    => 1, 
    init_arg  => undef,
    predicate => '_has_export', 
    default   => 1
); 

has 'project' => ( 
    is        => 'ro', 
    isa       => Project,
    coerce    => 1, 
    init_arg  => undef,
    predicate => '_has_project',
    default   => 'burst_buffer'
); 

has 'account' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    isa       =>  Account,
    coerce    => 1,
    predicate => '_has_account',
    default   => 'etc',
); 

has 'queue' => ( 
    is        => 'rw', 
    isa       => Queue,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_queue',
    default   => 'normal'
); 

has 'name' => ( 
    is        => 'rw', 
    isa       => Name, 
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_name',
    default   => 'jobname', 
); 

has 'stderr' => ( 
    is        => 'rw', 
    isa       => Stderr,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_stderr',
); 

has 'stdout' => ( 
    is        => 'rw', 
    isa       => Stdout,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_stdout',
); 

has 'resource' => ( 
    is        => 'rw', 
    isa       => Resource,
    coerce    => 1,
    lazy      => 1, 
    predicate => '_has_resource',
    clearer   => '_reset_resource',
    default   => sub { 
        my $self = shift; 

        my @resource; 
        push @resource, join('=', 'select'    , $self->select); 
        push @resource, join('=', 'ncpus'     , $self->ncpus );  
        push @resource, join('=', 'mpiprocs'  , ($self->_has_mpi ? $self->mpiprocs : 1));
        push @resource, join('=', 'ompthreads', ($self->_has_omp ? $self->omp      : 1)); 

        return [@resource]
    }
); 

has 'walltime' => (
    is        => 'rw',
    isa       => Walltime,
    traits    => ['Chained'],
    coerce    => 1, 
    predicate => '_has_walltime',
    default   => '48:00:00',
);

has 'select' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    default   => 1,
    predicate => '_has_select',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs; 
        $self->_reset_resource; 

        if ( $self->_has_mvapich2 ) { 
            $self->mvapich2->nprocs($self->select * $self->mpiprocs) 
        }

        $self->_reset_resource; 
    }
);

has 'ncpus' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    default   => 64,
    predicate => '_has_ncpus',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs;  
        $self->_reset_resource; 

        if ( $self->_has_mvapich2 ) { 
            $self->mvapich2->nprocs($self->select * $self->mpiprocs)
        }
        
        $self->_reset_resource; 
    }
);

has 'mpiprocs' => (
    is        => 'rw',
    isa       => Int,
    lazy      => 1,
    predicate => '_has_mpiprocs',
    clearer   => '_reset_mpiprocs', 
    default   => sub { 
        my $self = shift; 

        $self->_has_omp 
        ? $self->ncpus / $self->omp
        : $self->ncpus
    }
);

has 'omp' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_omp',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs; 
        $self->_reset_resource; 

        # mvapich2 requires both nprocs and omp
        if ($self->_has_mvapich2 ) { 
            $self->mvapich2->nprocs($self->select * $self->get_mpiprocs) 
                           ->omp($self->omp) 
        } 

        # openmpi requires only omp
        if ($self->_has_openmpi) { 
            $self->openmpi->omp($self->omp); 
        } 

        $self->_reset_resource; 
    }
);

sub _write_pbs_resource { 
    my $self = shift; 

    $self->printf("%s\n\n", $self->shell);  
    $self->resource; 

    for (qw(export account project queue name stderr stdout resource walltime)) { 
        my $has = "_has_$_"; 

        $self->printf("%s\n", $self->$_) if $self->$has; 
    } 

    $self->print("\n"); 
} 

1
