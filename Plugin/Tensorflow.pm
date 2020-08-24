package HPC::Plugin::Tensorflow; 

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Tensorflow'; 
use HPC::App::Tensorflow; 

use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'tensorflow' => (
    is        => 'rw', 
    isa       => Tensorflow,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_tensorflow',
    coerce    => 1,  
    trigger  => sub ($self, $app, @) { 
        # $self->account('tf'); 
        $self->_add_plugin('tf')
    }
); 

1
