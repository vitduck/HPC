package HPC::Types::Sched::Mpi; 

use MooseX::Types::Moose qw(Str); 
use MooseX::Types -declare => [qw(Impi Openmpi Mvapich2)]; 

class_type Impi,     { class => 'HPC::Mpi::Impi'     }; 
class_type Openmpi,  { class => 'HPC::Mpi::Openmpi'  }; 
class_type Mvapich2, { class => 'HPC::Mpi::Mvapich2' }; 

coerce Impi,     from Str, via { HPC::Mpi::Impi->new(module => $_)     }; 
coerce Openmpi,  from Str, via { HPC::Mpi::Openmpi->new(module => $_)  }; 
coerce Mvapich2, from Str, via { HPC::Mpi::Mvapich2->new(module => $_) }; 

1; 
