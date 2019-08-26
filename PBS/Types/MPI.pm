package HPC::PBS::Types::MPI; 

use IO::File; 
use MooseX::Types -declare => [qw(MPI IMPI OPENMPI MVAPICH2)]; 

use MooseX::Types::Moose qw/Undef Str Int Object/;  

class_type     IMPI, { class => 'HPC::MPI::IMPI'     }; 
class_type  OPENMPI, { class => 'HPC::MPI::OPENMPI'  }; 
class_type MVAPICH2, { class => 'HPC::MPI::MVAPICH2' }; 

# coerce     IMPI, from Str, via { my ($module, $version) = split /\//, $_;     HPC::MPI::IMPI->new(module  => $module, version => $version) };  
# coerce  OPENMPI, from Str, via { my ($module, $version) = split /\//, $_;  HPC::MPI::OPENMPI->new(module  => $module, version => $version) };  
# coerce MVAPICH2, from Str, via { my ($module, $version) = split /\//, $_; HPC::MPI::MVAPICH2->new(module  => $module, version => $version) };  

1; 
