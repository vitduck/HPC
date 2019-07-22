package HPC::MPI::CRAYIMPI; 

use Moose; 

with 'HPC::MPI::Module'; 

sub mpirun { return 'mpirun' }

__PACKAGE__->meta->make_immutable;

1; 
