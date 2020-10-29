package HPC::Plugin::Lammps; 

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Lammps'; 
use HPC::App::Lammps; 

use experimental 'signatures'; 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    init_arg  => undef,
    traits    => ['Chained'],
    predicate => '_has_lammps',
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { 
        $self->_add_plugin('lammps'); 
    }
); 

1
