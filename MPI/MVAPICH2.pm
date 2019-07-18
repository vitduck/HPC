package HPC::MPI::MVAPICH2;  

use Moose; 

sub mpirun { 
    my ($self, $select, $ncpus, $ompthreads) = @_; 

    my $nprocs = $select * $ncpus; 
    my $mpirun = "mpirun_rsh -np $nprocs -hostfile \$PBS_NODEFILE"; 
    
    return 
        $ompthreads == 1 ? 
        $mpirun:
        "$mpirun OMP_NUM_THREADS=$ompthreads"
} 

1; 
