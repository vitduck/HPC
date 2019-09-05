package HPC::PBS::Resource; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 
use HPC::PBS::Types::PBS qw(Shell Export Project Account Queue Name Resource Walltime Stdout Stderr); 

has 'shell' => ( 
    is      => 'rw', 
    isa     =>  Shell,
    coerce  => 1,
    writer  => 'set_shell',
    default => 'bash'
); 

has 'export' => ( 
    is       => 'ro', 
    isa      =>  Export,
    coerce   => 1, 
    init_arg => undef,
    default  => 1
); 

has 'project' => ( 
    is       => 'ro', 
    isa      => Project,
    coerce   => 1, 
    init_arg => undef,
    default  => 'burst_buffer'
); 

has 'account' => ( 
    is      => 'rw', 
    isa     =>  Account,
    coerce  => 1,
    writer  => 'set_account',
    default => 'etc',
); 

has 'queue' => ( 
    is      => 'rw', 
    isa     => Queue,
    coerce  => 1,
    writer  => 'set_queue',
    default => 'normal'
); 

has 'name' => ( 
    is      => 'rw', 
    isa     => Name, 
    coerce => 1,
    writer  => 'set_name',
    default => 'jobname', 
); 

has 'stderr' => ( 
    is     => 'rw', 
    isa    => Stderr,
    coerce => 1,
    writer => 'set_stderr',
); 

has 'stdout' => ( 
    is     => 'rw', 
    isa    => Stdout,
    coerce => 1,
    writer => 'set_stdout',
); 

has 'resource' => ( 
    is      => 'rw', 
    isa     => Resource,
    coerce  => 1,
    lazy    => 1, 
    clearer => '_reset_resource',
    default => sub { 
        my $self = shift; 

        my @resource; 
        push @resource, join('=', 'select'    , $self->select); 
        push @resource, join('=', 'ncpus'     , $self->ncpus );  
        push @resource, join('=', 'mpiprocs'  , ($self->has_mpi ? $self->mpiprocs : 1));
        push @resource, join('=', 'ompthreads', ($self->has_omp ? $self->omp      : 1)); 

        return [@resource]
    }
); 

has 'walltime' => (
    is      => 'rw',
    isa     => Walltime,
    coerce  => 1,
    writer  => 'set_walltime',
    default => '48:00:00',
);

has 'select' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_select',
    trigger => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs; 
        $self->_reset_resource; 
        $self->mvapich2->set_nprocs($self->select*$self->mpiprocs) if $self->_has_mvapich2;  
    }
);

has 'ncpus' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_ncpus',
    trigger => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs;  
        $self->_reset_resource; 
        $self->mvapich2->set_nprocs($self->select*$self->mpiprocs) if $self->_has_mvapich2; 
    }
);

has 'mpiprocs' => (
    is      => 'rw',
    isa     => Int,
    lazy    => 1,
    writer  => 'set_mpiprocs',
    clearer => '_reset_mpiprocs', 
    default => sub { 
        my $self = shift; 

        $self->has_omp 
        ? $self->ncpus / $self->omp
        : $self->ncpus
    }
);

has 'omp' => (
    is        => 'rw',
    isa       => Int,
    predicate => 'has_omp',
    writer    => 'set_omp',
    trigger   => sub { 
        my $self  = shift; 

        $self->_reset_mpiprocs; 
        $self->_reset_resource; 

        # mvapich2 requires both nprocs and omp
        if ($self->_has_mvapich2 ) { 
            $self->mvapich2->set_nprocs($self->select*$self->mpiprocs); 
            $self->mvapich2->set_omp($self->omp); 
        } 

        # openmpi requires only omp
        if ($self->_has_openmpi) { 
            $self->openmpi->set_omp($self->omp); 
        } 
    }
);

sub _write_pbs_resource { 
    my $self = shift; 

    $self->printf("%s\n\n", $self->shell);  

    for (qw(export account project queue name stderr stdout resource walltime)) { 
        $self->printf("%s\n", $self->$_) if $self->$_;  
    } 
} 

1
