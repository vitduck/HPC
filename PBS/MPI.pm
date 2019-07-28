package HPC::PBS::MPI; 

use Moose::Role; 

use HPC::MPI::Lib; 
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
    my @cmd  = (); 

    # mpirun 
    my $mpirun =
        $self->mpi->module eq 'mvapich2'
        ? join (' ', $self->mpi->mpirun, '-np', $self->select*$self->ncpus, '-hostfile', '$PBS_NODEFILE')
        : $self->mpi->mpirun;

    push @cmd, $mpirun, $self->mpi->env_opt; 

    # with openmp
    if ($self->omp > 1) {
        push @cmd, '--map-by NUMA:PE='.$self->omp if $self->mpi->module eq 'openmpi'; 
        push @cmd,  'OMP_NUM_THREADS='.$self->omp if $self->mpi->module eq 'mvapich2'; 
    } 

    return join ' ', @cmd; 
}

1 
