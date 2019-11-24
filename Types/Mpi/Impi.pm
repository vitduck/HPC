package HPC::Types::Mpi::Impi;

use IO::File;
use MooseX::Types::Moose qw(ArrayRef HashRef Str);  
use MooseX::Types -declare => [qw(Env Pin)]; 

subtype Env, as ArrayRef; 
subtype Pin, as Str, where { /allcores|\d/ }; 

coerce Env, from HashRef, via { 
    return 
        [map '-env '.$_.'='.$_[0]->{$_}, sort keys $_[0]->%*]
}; 

coerce Pin, from Str, via {
    for ($_) { 
        if    ( /bunch/   ) { return 'allcores:grain=fine:shift=1' }
        elsif ( /spread/  ) { return 'allcores:map=spread'         }
        elsif ( /scatter/ ) { return 'allcores:map=scatter'        }
    }
}; 

1
