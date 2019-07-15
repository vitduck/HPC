package HPC::MPI::IMPI; 

use Moose::Role;  

has 'I_MPI_DEBUG' => ( 
    is      => 'rw', 
    traits  => ['Bool'],
    isa     => 'Bool',
    default => 0, 
    handles => { enable_impi_debug => 'set' }, 
    trigger => sub { $ENV{I_MPI_DEBUG} = 5 }
);

has 'mpirun' => ( 
    is      => 'ro', 
    isa     => 'Str', 
    default => 'mpirun', 
); 

1; 
