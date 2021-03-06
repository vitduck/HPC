package HPC::App::Tensorflow::Device; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 
use Moose::Util::TypeConstraints; 

use experimental 'signatures';

has device => (
    is        => 'rw',
    isa       => enum([qw(cpu gpu)]),
    traits    => ['Chained'],
    predicate => '_has_device',
    required  => 1, 
    trigger   => sub ($self, $device, @) { 
        $self->horovod_device($device); 
        $self->local_parameter_device($device); 

        $self->mkl('true')                  if $device eq 'cpu'; 
        $self->use_fp16(1)->allow_growth(1) if $device eq 'gpu'; 
    } 
);

has horovod_device => (
    is        => 'rw',
    isa       => enum([qw(cpu gpu)]),
    traits    => ['Chained'],
    predicate => '_has_horovod_device', 
    lazy      => 1, 
    default   => 'cpu', 
    trigger   => sub ($self, @) { 
        $self->variable_update('horovod'); 
    }
);   

has variable_update => (
    is        => 'rw',
    isa       => Str, 
    traits    => ['Chained'],
    predicate => '_has_variable_update', 
    lazy      => 1, 
    default   => 'parameter_server', 
);   

has local_parameter_device => (
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_local_parameter_device', 
    lazy      => 1,  
    default   => 'cpu', 
);   

has sync_on_finish => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_sync_on_finish', 
    lazy      => 1, 
    default   => 'false', 
); 

1
