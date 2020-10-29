package HPC::Slurm::Srun; 

use Moose::Role; 

use namespace::autoclean;
use experimental 'signatures';

sub srun ($self) { 
    return 'srun'
} 

1
