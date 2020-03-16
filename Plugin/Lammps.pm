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
    predicate => '_has_lammps',
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { 
        $self->account('lammps'); 
        $self->_add_plugin('lammps'); 
        
        # pass ngpus to lammps gpu pkg command
        if ( $self->lammps->_has_gpu and $self->ngpus =~ /gpu:(\d+)/ ) {  
            $self->lammps->gpu->ngpu($1) 
        }
    }
); 

1
