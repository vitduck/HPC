package HPC::PBS::NUMA; 

use Moose::Role; 
use HPC::NUMA::HBW; 
use HPC::PBS::Types::NUMA qw(NUMA);  

has 'numa' => ( 
    is       => 'rw', 
    isa      => NUMA, 
    init_arg => undef, 
    default  => sub { HPC::NUMA::HBW->new }, 
    handles  => {  
        set_numa_membind   => 'set_membind',
        set_numa_preferred => 'set_preferred', 
        numa_mode          => 'cmd'
    } 
); 

1
