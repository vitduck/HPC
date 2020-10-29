package HPC::Ime::Stage; 

use Moose;  

use namespace::autoclean; 
use experimental 'signatures'; 

with 'HPC::Ime::Ctl'; 

has '+option' => ( 
    default => sub {['-i']}
); 

__PACKAGE__->meta->make_immutable;

1
