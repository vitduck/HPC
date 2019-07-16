package HPC::MPI::OPENMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Version'; 

sub mpirun { 
    my ($self, $ompthreads) = @_; 
    
    return 
        $ompthreads == 1 ? 
        "mpirun" : 
        "mpriun --map-by NUMA:PE=$ompthreads" 
} 


__PACKAGE__->meta->make_immutable;

1
