package HPC::Slurm::Srun; 

use Moose::Role; 

use feature 'signatures';
no warnings 'experimental::signatures';

sub srun ($self) { 
    return 'srun'
} 

1
