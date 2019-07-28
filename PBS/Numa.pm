package HPC::PBS::Numa;  

use Moose::Role; 
use HPC::PBS::Types qw/MCDRAM DDR4/; 

has mcdram => ( 
    is     => 'rw', 
    isa    => MCDRAM, 
    coerce => 1, 
); 

has ddr4 => ( 
    is   => 'rw', 
    isa  => DDR4, 
    coerce => 1, 
); 

1
