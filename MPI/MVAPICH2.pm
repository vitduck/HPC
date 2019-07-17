package HPC::MPI::MVAPICH2;  

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Module'; 

sub mpirun { 
    my ($self, $select, $ncpus, $ompthreads) = @_; 

    my $nprocs = $select * $ncpus; 
    my $mpirun = "mpirun_rsh -np $nprocs -hostfile \$PBS_NODEFILE"; 
    
    return 
        $ompthreads == 1 ? 
        $mpirun:
        "$mpirun OMP_NUM_THREADS=$ompthreads"
} 

__PACKAGE__->meta->make_immutable;

1; 
