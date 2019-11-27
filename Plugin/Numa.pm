package HPC::Plugin::Numa; 

use Moose::Role; 
use HPC::Types::Sched::Plugin 'Numa'; 
use HPC::Profile::Numa; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'numa' => (
    is        => 'rw', 
    isa       => Numa,
    init_arg  => undef,
    traits    => ['Chained'],
    predicate => '_has_numa',
    coerce    => 1, 
    trigger   => sub ($self, @) { 
        $self->_add_plugin('numa'); 
        $self->queue('flat') 
    } 
); 

1
