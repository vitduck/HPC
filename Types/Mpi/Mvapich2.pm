package HPC::Types::Mpi::Mvapich2; 

use IO::File; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Omp Env Pin)]; 

subtype Omp, 
    as Str ,     
    where { /^OMP_NUM_THREADS/ }; 
coerce Omp, 
    from Int,     
    via { 'OMP_NUM_THREADS='.$_ };  

subtype Pin, 
    as Str,      
    where { /\d\:|bunch|scatter|none/ }; 
coerce Pin, 
    from Str,     
    via { s/,/:/; $_ }; 

subtype Env, 
    as ArrayRef; 
coerce Env, 
    from HashRef, 
    via { [map $_.'='.$_[0]->{$_}, sort keys $_[0]->%*] };

1
