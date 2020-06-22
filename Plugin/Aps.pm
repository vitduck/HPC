package HPC::Plugin::Aps; 

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Aps'; 
use HPC::Profile::Aps; 

has 'aps' => ( 
    is        => 'rw', 
    isa       => Aps,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_aps',
    coerce    => 1, 
); 

1
