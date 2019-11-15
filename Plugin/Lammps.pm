package HPC::Plugin::Lammps; 

use Moose::Role; 
use HPC::Types::Sched::Plugin 'Lammps'; 
use HPC::App::Lammps; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    init_arg  => undef,
    traits    => ['Chained'],
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { $self->account('lammps') }
); 

1
