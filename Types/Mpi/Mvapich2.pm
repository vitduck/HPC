package HPC::Types::Mpi::Mvapich2; 

use IO::File; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Omp Env Pin)]; 

subtype Omp, as Str ,     where { /^OMP_NUM_THREADS/ }; 
subtype Pin, as Str,      where { /\d\:|bunch|scatter|none/ }; 
subtype Env, as ArrayRef; 

coerce Omp, from Int,     via { 'OMP_NUM_THREADS='.$_ };  
coerce Pin, from Str,     via { s/,/:/; $_ }; 
coerce Env, from HashRef, via { [map $_.'='.$_[0]->{$_}, sort keys $_[0]->%*] };

1
