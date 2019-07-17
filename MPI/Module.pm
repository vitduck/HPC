package HPC::MPI::Module; 

use Moose::Role;  

has 'module' => (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

has 'version' => (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

1; 
