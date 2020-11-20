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

        if ( $self->_has_omp ) { 
            if ( $self->lammps->_has_omp    ) { $self->lammps->omp->nthreads($self->omp) }
            if ( $self->lammps->_has_intel  ) { $self->lammps->intel->omp($self->omp)    } 
            
            # affinity for kokkos package
            if ( $self->lammps->_has_kokkos and $self->omp > 1 ) { 
                $self->lammps->kokkos_thr($self->omp); 
                $self->set_env( 
                    OMP_PROC_BIND => 'spread',  
                    OMP_PLACES    => 'threads' ); 
            }
        }

        if ( $self->_has_ngpus ) { 
            if ( $self->lammps->_has_gpu ) { 
                $self->lammps->gpu->ngpu($self->ngpus)
            }
        }
    }
); 

1
