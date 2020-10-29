package HPC::Ime::Sync; 

use Moose;  

use namespace::autoclean; 
use experimental 'signatures'; 

with 'HPC::Ime::Ctl'; 

has '+option' => ( 
    default => sub {['-r']}
); 

__PACKAGE__->meta->make_immutable;

1
