package HPC::PBS::Numa;  

use Moose::Role; 
use HPC::PBS::Types::Numa qw/Numa/; 

has numa => ( 
    is      => 'rw', 
    isa     => Numa, 
    coerce  => 1, 
    writer  => 'set_numa', 
    clearer => 'unset_numa'
); 

1
