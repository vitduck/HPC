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
    trigger  => sub ($self, @) { 
        $self->_set_lammps_omp if $self->_has_omp; 
        $self->_set_lammps_gpu if $self->_has_ngpus; 
    }
); 

1
