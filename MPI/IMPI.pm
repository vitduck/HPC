package HPC::MPI::IMPI; 

use Moose::Role; 

has 'I_MPI_DEBUG' => ( 
    is      => 'rw', 
    traits  => ['Bool'],
    isa     => 'Bool',
    default => 0, 
    handles => { 
         enable_mpi_debug => 'set', , 
        disable_mpi_debug => 'unset' 
    }
);

after  'enable_mpi_debug' => sub { $ENV{I_MPI_DEBUG} = 5 }; 
after 'disable_mpi_debug' => sub { $ENV{I_MPI_DEBUG} = 0 }; 

sub mpirun { return 'mpirun' }

1
