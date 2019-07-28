package HPC::MPI::IMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Lib'; 

has '+env_opt' => ( 
    default => '-env'
); 

__PACKAGE__->meta->make_immutable;

1
