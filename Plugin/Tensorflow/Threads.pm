package HPC::Plugin::Tensorflow::Threads; 

use Moose::Role;  
use MooseX::Types::Moose qw(Int); 

has num_inter_threads => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_num_inter_threads', 
    default   => 2
);   

has num_intra_threads => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_num_intra_threads', 
    default   => 32
);   

1
