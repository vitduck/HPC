package HPC::Plugin::Iterator; 

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Iterator'; 
use HPC::Sched::Iterator;  

has 'iterator' => ( 
    is        => 'rw', 
    isa       => Iterator,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_iterator',
    coerce    => 1, 
    handles   => [qw(list_scan list_iterator)]
); 

1
