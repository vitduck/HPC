package HPC::App::Tensorflow::Model; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 

has model => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_model', 
    required  => 1, 
); 

has data_format => (
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_data_format', 
    default   => 'NCHW',
); 

has 'data_name' => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_data_name', 
    lazy      => 1, 
    default   => 'imagenet',
); 

has 'data_dir' => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_data_dir', 
); 

has 'train_dir' => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_train_dir', 
); 

has batch_size => ( 
    is        => 'rw',
    isa       => Int,
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
    lazy      => 1,
    default   => 'profile.dat'
); 

1
