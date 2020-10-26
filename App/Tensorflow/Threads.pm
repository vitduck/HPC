package HPC::App::Tensorflow::Threads; 

use Moose::Role;  
use MooseX::Types::Moose 'Int'; 

has num_inter_threads => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_num_inter_threads', 
    lazy      => 1, 
    default   => 2
);   

has num_intra_threads => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_num_intra_threads',
    lazy      => 1, 
    default   => 32
);   

1
