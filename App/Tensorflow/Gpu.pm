package HPC::App::Tensorflow::Gpu; 

use Moose::Role; 
use MooseX::Types::Moose 'Int'; 

has allow_growth => ( 
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_allow_growth',
    lazy      => 1, 
    default   => 1, 
); 

has use_fp16 => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_use_fp16',
    lazy      => 1 , 
    default   => 1, 
);

1
