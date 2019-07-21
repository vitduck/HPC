package HPC::MPI::Module; 

use Moose; 
use namespace::autoclean; 

with 'MooseX::Traits'; 

has 'module' => (
    is       => 'ro', 
    isa      => 'Str', 
); 

has 'version' => (
    is       => 'ro', 
    isa      => 'Str', 
); 

__PACKAGE__->meta->make_immutable;

1 
