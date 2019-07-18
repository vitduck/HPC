package HPC::MPI::OPENMPI; 

use Moose::Role; 

sub mpirun { 
    my ($self, $omp) = @_; 
    
    return 
        $omp == 1 ? 
        "mpirun" : 
        "mpriun --map-by NUMA:PE=$omp" 
} 

1
