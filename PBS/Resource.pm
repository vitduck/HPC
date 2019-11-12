package HPC::PBS::Resource; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 

use HPC::PBS::Types::PBS qw(Shell Export Project Account Queue Name Resource Walltime Stdout Stderr); 

use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'shell' => ( 
    is        => 'rw', 
    isa       =>  Shell,
    traits    => ['Chained'],
    predicate => '_has_shell',
    coerce    => 1,
    default   => 'bash' 
); 

has 'export' => ( 
    is        => 'ro', 
    isa       =>  Export,
    init_arg  => undef,
    predicate => '_has_export', 
    coerce    => 1, 
    default   => 1 
); 

has 'project' => ( 
    is        => 'ro', 
    isa       => Project,
    init_arg  => undef,
    predicate => '_has_project',
    coerce    => 1, 
    lazy      => 1,
    default   => 'burst_buffer' 
); 

has 'account' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    isa       =>  Account,
    predicate => '_has_account',
    default   => 'etc',
    coerce    => 1 
); 

has 'queue' => ( 
    is        => 'rw', 
    isa       => Queue,
    traits    => ['Chained'],
    predicate => '_has_queue',
    coerce    => 1,
    default   => 'normal' 
); 

has 'name' => ( 
    is        => 'rw', 
    isa       => Name, 
    traits    => ['Chained'],
    predicate => '_has_name',
    coerce    => 1,
    default   => 'jobname' 
); 

has 'stderr' => ( 
    is        => 'rw', 
    isa       => Stderr,
    traits    => ['Chained'],
    predicate => '_has_stderr',
    coerce    => 1 
); 

has 'stdout' => ( 
    is        => 'rw', 
    isa       => Stdout,
    traits    => ['Chained'],
    predicate => '_has_stdout',
    coerce    => 1 
); 

has 'resource' => ( 
    is        => 'rw', 
    isa       => Resource,
    traits    => ['Chained'],
    predicate => '_has_resource',
    clearer   => '_reset_resource',
    coerce    => 1,
    lazy      => 1, 
    default   => sub ($self) { 
        my @resource; 

        push @resource, join('=', 'select'    ,  $self->select); 
        push @resource, join('=', 'ncpus'     ,  $self->ncpus );  
        push @resource, join('=', 'mpiprocs'  , ($self->_has_mpi ? $self->mpiprocs : 1));
        push @resource, join('=', 'ompthreads', ($self->_has_omp ? $self->omp      : 1)); 

        return [@resource]
    }
); 

has 'walltime' => (
    is        => 'rw',
    isa       => Walltime,
    traits    => ['Chained'],
    predicate => '_has_walltime',
    coerce    => 1, 
    default   => '48:00:00' 
);

has 'select' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_select',
    default   => 1,
    trigger   => sub ($self, $) { 
        $self->_reset_resource; 
        $self->mvapich2->nprocs($self->select*$self->mpiprocs) if $self->_has_mvapich2; 
    }
);

has 'ncpus' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ncpus',
    default   => 64,
    trigger   => sub ($self,$) { 
        $self->_reset_resource; 
        $self->mvapich2->nprocs($self->select*$self->mpiprocs) if $self->_has_mvapich2
    }
);

has 'mpiprocs' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_mpiprocs',
    clearer   => '_reset_mpiprocs', 
    lazy      => 1,
    default   => sub ($self) { 
        $self->ncpus 
    }
);

has 'omp' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_omp',
    trigger   => sub ($self, $) { 
        $self->_reset_resource; 
        $self->mvapich2->nprocs($self->select*$self->get_mpiprocs)->omp($self->omp) if $self->_has_mvapich2; 
        $self->openmpi->omp($self->omp)                                             if $self->_has_openmpi;  
    }
);

sub _write_pbs_resource ($self) { 
    $self->_write_shell;     

    # others
    for (qw(export account project queue name stderr stdout resource walltime)) { 
        my $has = "_has_$_"; 
        $self->printf("%s\n", $self->$_) if $self->$has; 
    } 
} 

sub _write_shell ($self) { 
    # shell 
    $self->printf("%s\n\n", $self->shell);  
} 

1
