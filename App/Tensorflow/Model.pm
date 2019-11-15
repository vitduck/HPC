package HPC::App::Tensorflow::Model; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 

has model => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_model', 
    default   => 'resnet50'
); 

has data_format => (
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_data_format', 
    default   => 'NCHW',
);   

has batch_size => ( 
    is        => 'rw',
    isa       => Str,
    lazy      => 1,
    traits    => ['Chained'],
    predicate => '_has_batch_size', 
    default   => 64
); 

has optimizer => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_optimizer', 
    default   => 'sgd'
); 

has tfprof_file => ( 
    is        => 'rw',
    isa       => Str,
    lazy      => 1,
    traits    => ['Chained'],
    predicate => '_has_tfprof_file', 
    default   => 'profile.dat'
); 

1
