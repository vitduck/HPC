package HPC::Plugin::Mpi; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str HashRef); 

use HPC::Mpi::Impi;
use HPC::Mpi::Openmpi;
use HPC::Mpi::Mvapich2;
use HPC::Types::Sched::Mpi qw(Impi Openmpi Mvapich2); 

use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'impi' => (
    is        => 'rw', 
    isa       => Impi, 
    init_arg  => undef, 
    predicate => '_has_impi', 
    writer    => '_load_impi',
    clearer   => '_unload_impi', 
    coerce    => 1, 
); 

has 'openmpi' => (
    is        => 'rw', 
    isa       => Openmpi, 
    init_arg  => undef, 
    predicate => '_has_openmpi', 
    writer    => '_load_openmpi',
    clearer   => '_unload_openmpi', 
    coerce    => 1, 
); 

has 'mvapich2' => (
    is        => 'rw', 
    isa       => Mvapich2, 
    init_arg  => undef, 
    predicate => '_has_mvapich2',
    writer    => '_load_mvapich2',
    clearer   => '_unload_mvapich2', 
    coerce    => 1, 
); 

sub mpirun ($self) { 
    if    ( $self->_has_impi     ) { return $self->impi->cmd     } 
    elsif ( $self->_has_openmpi  ) { return $self->openmpi->cmd  }  
    elsif ( $self->_has_mvapich2 ) { return $self->mvapich2->cmd }  
} 

1
