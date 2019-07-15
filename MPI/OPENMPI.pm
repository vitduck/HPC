package HPC::MPI::OPENMPI; 

use Moose::Role; 

has 'mpirun' => ( 
    is      => 'ro', 
    isa     => 'Str', 
    default => 'mpirun', 
); 

1; 
