package HPC::MPI::CRAYIMPI; 

use Moose;  
use namespace::autoclean; 

with 'HPC::MPI::Module'; 

__PACKAGE__->meta->make_immutable;

1; 
