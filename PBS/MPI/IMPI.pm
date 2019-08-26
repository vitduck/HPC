package HPC::PBS::MPI::IMPI; 

use Moose::Role; 
use HPC::PBS::Types::MPI qw(IMPI); 
use HPC::MPI::IMPI; 

has 'mpi' => (
    is       => 'rw', 
    isa       => IMPI, 
    init_arg  => undef, 
    clearer   => 'unload_mpi', 
    default   => sub { HPC::MPI::IMPI->new }, 
    handles => { 
        set_impi_env   => 'set_env', 
        set_impi_debug => 'set_debug',
        set_impi_eager => 'set_eagersize',
        mpirun         => 'mpirun'
    }
); 

1; 
