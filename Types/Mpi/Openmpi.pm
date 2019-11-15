package HPC::Types::Mpi::Openmpi; 

use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Mca Env Omp)]; 

subtype Omp, as Str     , where { /\-\-map\-by/ }; 
subtype Env, as ArrayRef; 
subtype Mca, as ArrayRef; 

coerce Omp, from Int,     via { return '--map-by NUMA:PE='.$_ };
coerce Env, from HashRef, via { [map   '-x '.$_.'='.$_[0]->{$_}, sort keys $_[0]->%*] }; 
coerce Mca, from HashRef, via { [map '-mca '.$_.' '.$_[0]->{$_}, sort keys $_[0]->%*] }; 

1
