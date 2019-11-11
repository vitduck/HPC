package HPC::MPI::Types::OPENMPI; 

use IO::File; 
use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(OMP_OPENMPI ENV_OPENMPI MCA_OPENMPI)]; 

subtype OMP_OPENMPI, as Str, where { /\-\-map\-by/ }; 
subtype ENV_OPENMPI, as ArrayRef; 
subtype MCA_OPENMPI, as ArrayRef; 

coerce OMP_OPENMPI, from Int,     via { return '--map-by NUMA:PE='.$_ };
coerce ENV_OPENMPI, from HashRef, via { my $env = $_; [map   '-x '.$_.'='.$env->{$_}, sort keys $env->%*] }; 
coerce MCA_OPENMPI, from HashRef, via { my $mca = $_; [map '-mca '.$_.' '.$mca->{$_}, sort keys $mca->%*] }; 

1
