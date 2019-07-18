package HPC::MPI::OPENMPI; 

use Moose::Role; 

sub mpirun { 
    my ($self, $ompthreads) = @_; 
    
    return 
        $ompthreads == 1 ? 
        "mpirun" : 
        "mpriun --map-by NUMA:PE=$ompthreads" 
} 

1
