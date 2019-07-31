package HPC::PBS::Numa;  

use Moose::Role; 
use HPC::PBS::Types qw/NUMA/; 

has numa => ( 
    is      => 'rw', 
    isa     => NUMA, 
    coerce  => 1, 
    writer  => 'set_numa', 
    clearer => 'unset_numa'
); 

1
