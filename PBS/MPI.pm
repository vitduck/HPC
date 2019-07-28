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
    handles  => { 
          set_mpi_env => 'set_env', 
        unset_mpi_env => 'unset_env', 
        reset_mpi_env => 'reset_env'
    } 
); 

sub mpirun { 
    my $self = shift; 
    my @opts = ( $self->mpi->cmd(
        $self->select, 
        $self->ncpus, 
        $self->omp)
    );  

    # flat mode
    splice @opts, 1, 0, $self->mcdram if $self->mcdram; 
    splice @opts, 1, 0, $self->ddr4   if $self->ddr4; 

    return join ' ', @opts 
}

1 
