package HPC::Plugin::Qe;  

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Qe'; 
use HPC::App::Qe; 

use experimental 'signatures'; 

has 'qe' => (
    is        => 'rw', 
    isa       => Qe,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_qe', 
    coerce    => 1, 
    # trigger   => sub ($self, $app, @) { 
        # $self->_add_plugin('qe')
    # }
); 

1
