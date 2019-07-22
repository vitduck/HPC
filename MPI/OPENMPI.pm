package HPC::MPI::OPENMPI; 

use Moose; 

with 'HPC::MPI::Module'; 

sub mpirun { 
    my ($self,$omp) = @_; 
    
    return 
        $omp == 1  
        ? "mpirun"  
        : "mpriun --map-by NUMA:PE=$omp"
} 

__PACKAGE__->meta->make_immutable;

1
