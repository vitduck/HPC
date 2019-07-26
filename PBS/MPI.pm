package HPC::PBS::MPI; 

use Moose::Role; 

use HPC::MPI::IMPI; 
use HPC::MPI::OPENMPI; 
use HPC::MPI::MVAPICH2; 
use HPC::MPI::Types qw/MPI/; 

has mpi => (
    is        => 'rw',
    isa       => MPI,
    init_arg  => undef,
    coerce    => 1, 
    writer    => '_load_mpi', 
    clearer   => '_unload_mpi', 
    predicate => 'has_mpi',
    trigger   => sub { 
        my $self = shift; 

        $self->mpi->omp($self->omp); 
    }
); 

1 
