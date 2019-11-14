package HPC::Plugin::Types::OPENMPI; 

use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(OMP_OPENMPI ENV_OPENMPI MCA_OPENMPI)]; 

subtype OMP_OPENMPI, as Str, where { /\-\-map\-by/ }; 
subtype ENV_OPENMPI, as ArrayRef; 
subtype MCA_OPENMPI, as ArrayRef; 

coerce OMP_OPENMPI, from Int,     via { return '--map-by NUMA:PE='.$_ };
coerce ENV_OPENMPI, from HashRef, via { [map   '-x '.$_.'='.$_[0]->{$_}, sort keys $_[0]->%*] }; 
coerce MCA_OPENMPI, from HashRef, via { [map '-mca '.$_.' '.$_[0]->{$_}, sort keys $_[0]->%*] }; 

1
