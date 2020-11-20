package HPC::Slurm::Srun; 

use Moose::Role; 

use namespace::autoclean;
use experimental 'signatures';

sub srun ($self) { 
    $self->set_env( OMP_NUM_THREADS => $self->omp           ) if $self->_has_omp; 
    $self->set_env( MVAPICH2        => $self->mvapich2->env ) if $self->_has_mvapich2 and $self->mvapich2->has_env; 

    return 'srun'
} 

1
