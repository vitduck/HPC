package HPC::Pbs::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int);
use HPC::Types::Sched::Pbs qw(Export Project  Resource); 
use feature 'signatures';
no warnings 'experimental::signatures';

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

has 'mpiprocs' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_mpiprocs',
    clearer   => '_reset_mpiprocs', 
    lazy      => 1,
    default   => sub ($self, @) { $self->ncpus } 
);

has 'omp' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_omp',
    trigger   => sub ($self, @) { 
        $self->_reset_resource; 
        $self->mvapich2->nprocs($self->select*$self->get_mpiprocs)->omp($self->omp) if $self->_has_mvapich2; 
        $self->openmpi->omp($self->omp)                                             if $self->_has_openmpi;  
    }
);

has 'resource' => ( 
    is        => 'rw', 
    isa       => Resource,
    init_arg  => undef,
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

1
