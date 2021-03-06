package HPC::Plugin::Mpi; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str HashRef); 

use HPC::Mpi::Impi;
use HPC::Mpi::Openmpi;
use HPC::Mpi::Mvapich2;
use HPC::Types::Sched::Mpi qw(Impi Openmpi Mvapich2); 

use namespace::autoclean; 
use experimental 'signatures';  

has 'impi' => (
    is        => 'rw', 
    isa       => Impi, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_impi', 
    clearer   => '_unset_impi', 
    coerce    => 1, 
    lazy      => 1,
    default   => sub {{}},
); 

has 'openmpi' => (
    is        => 'rw', 
    isa       => Openmpi, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_openmpi', 
    clearer   => '_unset_openmpi', 
    coerce    => 1, 
    lazy      => 1,
    default   => sub {{}},
    trigger   => sub ($self, @) { 
        $self->openmpi->nprocs($self->nprocs); 
        $self->openmpi->omp($self->omp) if $self->_has_omp;  
    } 
); 

has 'mvapich2' => (
    is        => 'rw', 
    isa       => Mvapich2, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_mvapich2',
    clearer   => '_unset_mvapich2', 
    coerce    => 1, 
    lazy      => 1,
    default   => sub {{}},
    trigger   => sub ($self, @) { 
        $self->mvapich2->omp($self->omp) if $self->_has_omp;  
    } 
); 

sub mpirun ($self) { 
    if    ( $self->_has_impi     ) { return $self->impi->cmd     } 
    elsif ( $self->_has_openmpi  ) { return $self->openmpi->cmd  }  
    elsif ( $self->_has_mvapich2 ) { return $self->mvapich2->cmd }  
} 

1
