package HPC::PBS::MPI::MVAPICH2; 

use Moose::Role; 
use HPC::PBS::Types::MPI qw(MVAPICH2); 
use HPC::MPI::MVAPICH2; 

has 'mpi' => (
    is       => 'rw', 
    isa       => MVAPICH2, 
    init_arg  => undef, 
    clearer   => 'unload_mpi', 
    default   => sub { HPC::MPI::MVAPICH2->new }, 
    handles => { 
        set_mvapich2_env   => 'set_env', 
        set_mvapich2_eager => 'set_eagersize', 
        mpirun             => 'mpirun',
    }
); 

1; 
