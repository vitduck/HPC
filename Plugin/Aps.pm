package HPC::Plugin::Aps; 

use Moose::Role; 
use HPC::Types::Sched::Plugin 'Aps'; 
use HPC::Profile::Aps; 

has 'aps' => ( 
    is       => 'rw', 
    isa      => Aps,
    init_arg => undef, 
    coerce   => 1, 
    traits   => ['Chained'],
); 

1
