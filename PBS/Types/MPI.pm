package HPC::PBS::Types::MPI; 

use MooseX::Types -declare => [qw(IMPI OPENMPI MVAPICH2)]; 
use MooseX::Types::Moose qw(Str); 

class_type     IMPI, { class => 'HPC::MPI::IMPI'     }; 
class_type  OPENMPI, { class => 'HPC::MPI::OPENMPI'  }; 
class_type MVAPICH2, { class => 'HPC::MPI::MVAPICH2' }; 

coerce     IMPI, from Str, via {     HPC::MPI::IMPI->new(module => $_) }; 
coerce  OPENMPI, from Str, via {  HPC::MPI::OPENMPI->new(module => $_) }; 
coerce MVAPICH2, from Str, via { HPC::MPI::MVAPICH2->new(module => $_) }; 

1; 
