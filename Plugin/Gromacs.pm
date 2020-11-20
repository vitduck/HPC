package HPC::Plugin::Gromacs; 

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Gromacs'; 
use HPC::App::Gromacs; 

use experimental 'signatures'; 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_gromacs',
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { 
        if ( $self->_has_omp ) { $self->_set_gromacs_omp }

        if ( $self->gromacs->_has_gpudirect ) { 
            $self->set_env( 
                GMX_GPU_DD_COMMS             => 'true', 
                GMX_GPU_PME_PP_COMMS         => 'true', 
                GMX_FORCE_UPDATE_DEFAULT_GPU => 'true'
            )
        } 
    }
); 

1
