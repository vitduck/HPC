package HPC::MPI::MVAPICH2;  

use Moose; 

sub mpirun { 
    my ($self, $select, $ncpus, $omp) = @_; 

    my $nprocs = $select * $ncpus; 
    my $mpirun = "mpirun_rsh -np $nprocs -hostfile \$PBS_NODEFILE"; 
    
    return 
        $omp == 1 ? 
        $mpirun:
        "$mpirun OMP_NUM_THREADS=$omp"
} 

1; 
