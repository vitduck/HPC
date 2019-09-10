package HPC::PBS::Resource; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 
use HPC::PBS::Types::PBS qw(Shell Export Project Account Queue Name Resource Walltime Stdout Stderr); 

has 'shell' => ( 
    is        => 'rw', 
    isa       =>  Shell,
    coerce    => 1,
    reader    => 'get_shell',
    writer    => 'set_shell',
    predicate => '_has_shell',
    default   => 'bash'
); 

has 'export' => ( 
    is        => 'ro', 
    isa       =>  Export,
    coerce    => 1, 
    init_arg  => undef,
    reader    => 'get_export',
    predicate => '_has_export', 
    default   => 1
); 

has 'project' => ( 
    is        => 'ro', 
    isa       => Project,
    coerce    => 1, 
    init_arg  => undef,
    reader    => 'get_project',
    predicate => '_has_project',
    default   => 'burst_buffer'
); 

has 'account' => ( 
    is        => 'rw', 
    isa       =>  Account,
    coerce    => 1,
    reader    => 'get_account',
    writer    => 'set_account',
    predicate => '_has_account',
    default   => 'etc',
); 

has 'queue' => ( 
    is        => 'rw', 
    isa       => Queue,
    coerce    => 1,
    reader    => 'get_queue',
    writer    => 'set_queue',
    predicate => '_has_queue',
    default   => 'normal'
); 

has 'name' => ( 
    is        => 'rw', 
    isa       => Name, 
    coerce    => 1,
    reader    => 'get_name',
    writer    => 'set_name',
    predicate => '_has_name',
    default   => 'jobname', 
); 

has 'stderr' => ( 
    is        => 'rw', 
    isa       => Stderr,
    coerce    => 1,
    reader    => 'get_stderr',
    writer    => 'set_stderr',
    predicate => '_has_stderr',
); 

has 'stdout' => ( 
    is        => 'rw', 
    isa       => Stdout,
    coerce    => 1,
    reader    => 'get_stdout',
    writer    => 'set_stdout',
    predicate => '_has_stdout',
); 

has 'resource' => ( 
    is        => 'rw', 
    isa       => Resource,
    coerce    => 1,
    lazy      => 1, 
    reader    => 'get_resource',
    writer    => 'set_resource',
    predicate => '_has_resource',
    clearer   => '_reset_resource',
    default   => sub { 
        my $self = shift; 

        my @resource; 
        push @resource, join('=', 'select'    , $self->get_select); 
        push @resource, join('=', 'ncpus'     , $self->get_ncpus );  
        push @resource, join('=', 'mpiprocs'  , ($self->_has_mpi ? $self->get_mpiprocs : 1));
        push @resource, join('=', 'ompthreads', ($self->_has_omp ? $self->get_omp      : 1)); 

        return [@resource]
    }
); 

has 'walltime' => (
    is        => 'rw',
    isa       => Walltime,
    coerce    => 1, 
    reader    => 'get_walltime',
    writer    => 'set_walltime',
    predicate => '_has_walltime',
    default   => '48:00:00',
);

has 'select' => (
    is        => 'rw',
    isa       => Int,
    default   => 1,
    reader    => 'get_select',
    writer    => 'set_select',
    predicate => '_has_select',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs; 
        $self->_reset_resource; 

        if ( $self->_has_mvapich2 ) { 
            $self->mvapich2->set_nprocs($self->get_select * $self->get_mpiprocs) 
        }
    }
);

has 'ncpus' => (
    is        => 'rw',
    isa       => Int,
    default   => 1,
    reader    => 'get_ncpus',
    writer    => 'set_ncpus',
    predicate => '_has_ncpus',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs;  
        $self->_reset_resource; 

        if ( $self->_has_mvapich2 ) { 
            $self->mvapich2->set_nprocs($self->get_select * $self->get_mpiprocs)
        }
    }
);

has 'mpiprocs' => (
    is        => 'rw',
    isa       => Int,
    lazy      => 1,
    reader    => 'get_mpiprocs',
    writer    => 'set_mpiprocs',
    predicate => '_has_mpiprocs',
    clearer   => '_reset_mpiprocs', 
    default   => sub { 
        my $self = shift; 

        $self->_has_omp 
        ? $self->get_ncpus / $self->get_omp
        : $self->get_ncpus
    }
);

has 'omp' => (
    is        => 'rw',
    isa       => Int,
    reader    => 'get_omp',
    writer    => 'set_omp',
    predicate => '_has_omp',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs; 
        $self->_reset_resource; 

        # mvapich2 requires both nprocs and omp
        if ($self->_has_mvapich2 ) { 
            $self->mvapich2->set_nprocs($self->get_select * $self->get_mpiprocs); 
            $self->mvapich2->set_omp($self->get_omp); 
        } 

        # openmpi requires only omp
        if ($self->_has_openmpi) { 
            $self->openmpi->set_omp($self->get_omp); 
        } 
    }
);

sub _write_pbs_resource { 
    my $self = shift; 

    $self->printf("%s\n\n", $self->get_shell);  

    for (qw(export account project queue name stderr stdout resource walltime)) { 
        my $has = "_has_$_"; 
        my $get = "get_$_"; 

        $self->printf("%s\n", $self->$get) if $self->$has;  
    } 

    $self->print("\n"); 
} 

1
