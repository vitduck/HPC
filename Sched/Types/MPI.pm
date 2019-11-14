package HPC::Sched::Types::MPI; 

use MooseX::Types -declare => [qw(IMPI OPENMPI MVAPICH2)]; 
use MooseX::Types::Moose qw(Str); 
use HPC::Plugin::IMPI; 
use HPC::Plugin::OPENMPI; 
use HPC::Plugin::MVAPICH2; 

class_type     IMPI, { class => 'HPC::Plugin::IMPI'     }; 
class_type  OPENMPI, { class => 'HPC::Plugin::OPENMPI'  }; 
class_type MVAPICH2, { class => 'HPC::Plugin::MVAPICH2' }; 

coerce     IMPI, from Str, via {     HPC::Plugin::IMPI->new(module => $_) }; 
coerce  OPENMPI, from Str, via {  HPC::Plugin::OPENMPI->new(module => $_) }; 
coerce MVAPICH2, from Str, via { HPC::Plugin::MVAPICH2->new(module => $_) }; 

1; 
