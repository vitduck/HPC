package HPC::MPI::Lib; 

use Moose;  

with 'MooseX::Traits'; 

has 'lib' => (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

has 'version' => (
    is       => 'ro', 
    isa      => 'Str', 
    required => 1, 
); 

__PACKAGE__->meta->make_immutable;

1; 
