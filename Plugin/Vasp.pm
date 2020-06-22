package HPC::Plugin::Vasp;  

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Vasp'; 
use HPC::App::Vasp; 

use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'vasp' => (
    is        => 'rw', 
    isa       => Vasp,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_vasp', 
    coerce    => 1, 
    trigger   => sub ($self, $app, @) { 
        $self->account('vasp'); 
        $self->_add_plugin('vasp')
    }
); 

1
