package HPC::Plugin::Tensorflow::Device; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 
use Moose::Util::TypeConstraints; 

has device => (
    is        => 'rw',
    isa       => enum([qw(cpu gpu)]),
    traits    => ['Chained'],
    predicate => '_has_device',
    default   => 'cpu',
);

has horovod_device => (
    is        => 'rw',
    isa       => enum([qw(cpu gpu)]),
    traits    => ['Chained'],
    predicate => '_has_horovod_device', 
    lazy      => 1, 
    default   => 'cpu', 
    trigger   => sub { shift->variable_update('horovod') }
);   

has variable_update => (
    is        => 'rw',
    isa       => Str, 
    traits    => ['Chained'],
    predicate => '_has_variable_update', 
    default   => 'parameter_server'
);   

has local_parameter_device => (
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_local_parameter_device', 
    default   => 'cpu'
);   

has sync_on_finish => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_sync_on_finish', 
    default   => 'false', 
); 

1
