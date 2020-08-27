package HPC::Types::Mpi::Mvapich2; 

use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Omp Env)]; 
use IO::File; 

subtype Omp, as   Str, where { /^OMP_NUM_THREADS/    }; 
coerce  Omp, from Int, via   { 'OMP_NUM_THREADS='.$_ };  

subtype Env, as  ArrayRef; 
coerce  Env, from HashRef, via { [map $_.'='.$_[0]->{$_}, sort keys $_[0]->%*] };

1
