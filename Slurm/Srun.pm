package HPC::Slurm::Srun; 

use Moose::Role; 
use feature 'signatures';
no warnings 'experimental::signatures';

sub srun ($self) { 
    my $mpi; 

    if ($self->_has_mpi) { 
        $mpi = $self->_get_mpi; 
        $self->set($self->$mpi->env->%*) if $mpi; 
    }
    
    return 'srun'
} 

1
