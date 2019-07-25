package HPC::MPI::MVAPICH2;  

use Moose; 
use MooseX::Types::Moose qw/Int/; 
use Env qw/MV2_SMP_EAGERSIZE/; 

with 'HPC::MPI::Module'; 

has 'MV2_SMP_EAGERSIZE' => ( 
    is       => 'rw', 
    isa      => Int,
    init_arg => undef, 
    trigger  => sub { $MV2_SMP_EAGERSIZE = shift->MV2_SMP_EAGERSIZE }
);  

sub reset_mpi_env { 
    my $self = shift; 

    undef $MV2_SMP_EAGERSIZE 
} 

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
