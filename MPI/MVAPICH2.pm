package HPC::MPI::MVAPICH2; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Lib'; 

has '+mpirun' => (
    default => 'mpirun_rsh'
);

around cmd => sub {
    my ($cmd, $self, $select, $ncpus, $omp) = @_; 

    # original cmd 
    my @cmd = $self->$cmd; 

    # add after mpirun_rsh
    splice @cmd, 1, 0, ('-np', $select * $ncpus, '-hostfile', '$PBS_NODEFILE'); 

    # add after mpi environment
    push   @cmd, 'OMP_NUM_THREADS='.$omp if $omp > 1; 

    return @cmd; 
};

__PACKAGE__->meta->make_immutable;

1
