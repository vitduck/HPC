package HPC::PBS::MPI; 

use Moose::Role; 
use HPC::MPI::IMPI; 
use HPC::MPI::OPENMPI; 
use HPC::MPI::MVAPICH2; 
use HPC::PBS::Types::MPI qw(IMPI OPENMPI MVAPICH2); 

has 'impi' => (
    is        => 'rw', 
    isa       => IMPI, 
    coerce    => 1, 
    init_arg  => undef, 
    writer    => '_load_impi',
    predicate => '_has_impi', 
    clearer   => '_unload_impi', 
); 

# openmpi requires omp 
has 'openmpi' => (
    is        => 'rw', 
    isa       => OPENMPI, 
    init_arg  => undef, 
    coerce    => 1, 
    writer    => '_load_openmpi',
    predicate => '_has_openmpi', 
    clearer   => '_unload_openmpi', 
    trigger   => sub { 
        my $self = shift; 

        if ( $self->_has_omp ) { 
            $self->openmpi->omp($self->omp) 
        }
    }
); 

# mvapich2 requires nprocs and omp 
has 'mvapich2' => (
    is        => 'rw', 
    isa       => MVAPICH2, 
    init_arg  => undef, 
    coerce    => 1, 
    writer    => '_load_mvapich2',
    predicate => '_has_mvapich2',
    clearer   => '_unload_mvapich2', 
    handles => { 
        set_mvapich2_env   => 'set_env', 
        set_mvapich2_eager => 'set_eagersize', 
    }, 
    trigger  => sub {  
        my $self = shift; 

        $self->mvapich2->nprocs($self->select * $self->mpiprocs);

        if ( $self->_has_omp ) {  
            $self->mvapich2->omp($self->omp) 
        }
    }
); 

sub _has_mpi { 
    my $self = shift; 
    
    for my $mpi (qw(impi openmpi mvapich2)) { 
        my $has = "_has_$mpi"; 

        return 1 if $self->$has; 
    }
}

sub _get_mpi { 
    my $self = shift; 

    for my $mpi (qw(impi openmpi mvapich2)) { 
        my $has = "_has_$mpi"; 

        return $mpi if $self->$has; 
    }
} 

sub mpirun { 
    my $self = shift; 

    my $mpi = $self->_get_mpi; 
    
    return $self->$mpi->cmd
} 

1
