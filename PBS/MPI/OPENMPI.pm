package HPC::PBS::MPI::OPENMPI; 

use Moose::Role; 
use HPC::PBS::Types::MPI qw(OPENMPI); 
use HPC::MPI::OPENMPI; 

has 'mpi' => (
    is       => 'rw', 
    isa       => OPENMPI, 
    coerce    => 1, 
    init_arg  => undef, 
    clearer   => 'unload_mpi', 
    default   => sub { HPC::MPI::OPENMPI->new }, 
    handles => { 
        set_openmpi_env   => 'set_env', 
        set_openmpi_eager => 'set_eagersize', 
        mpirun            => 'mpirun',
    }
); 

1; 
