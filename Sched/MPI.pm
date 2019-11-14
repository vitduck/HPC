package HPC::Sched::MPI; 

use Moose::Role; 
use HPC::Sched::Types::MPI qw(IMPI OPENMPI MVAPICH2); 
use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'impi' => (
    is        => 'rw', 
    isa       => IMPI, 
    init_arg  => undef, 
    predicate => '_has_impi', 
    writer    => '_load_impi',
    clearer   => '_unload_impi', 
    coerce    => 1 
); 

# openmpi requires omp 
has 'openmpi' => (
    is        => 'rw', 
    isa       => OPENMPI, 
    init_arg  => undef, 
    predicate => '_has_openmpi', 
    writer    => '_load_openmpi',
    clearer   => '_unload_openmpi', 
    coerce    => 1, 
    trigger   => sub ($self, @) { 
        $self->openmpi->omp($self->omp) if $self->_has_omp 
    }
); 

# mvapich2 requires nprocs and omp 
has 'mvapich2' => (
    is        => 'rw', 
    isa       => MVAPICH2, 
    init_arg  => undef, 
    predicate => '_has_mvapich2',
    writer    => '_load_mvapich2',
    clearer   => '_unload_mvapich2', 
    coerce    => 1, 
    trigger   => sub ($self, @) {
        $self->mvapich2->nprocs($self->select*$self->mpiprocs);
        $self->mvapich2->omp($self->omp) if $self->_has_omp; 
    }
); 

sub _has_mpi ($self) { 
    for my $mpi (qw(impi openmpi mvapich2)) { 
        my $has = "_has_$mpi"; 

        return 1 if $self->$has; 
    }
}

sub _get_mpi ($self) { 
    for my $mpi (qw(impi openmpi mvapich2)) { 
        my $has = "_has_$mpi"; 

        return $mpi if $self->$has; 
    }
} 

sub mpirun ($self) { 
    my $mpi  = $self->_get_mpi; 
    
    return $self->$mpi->cmd
} 

1
