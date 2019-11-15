package HPC::Types::Mpi::Impi; 

use IO::File;
use MooseX::Types::Moose qw(ArrayRef HashRef);  
use MooseX::Types -declare => ['Env']; 

subtype Env, as    ArrayRef; 
coerce  Env, from   HashRef, via { [map '-env '.$_.'='.$_[0]->{$_}, sort keys $_[0]->%*] }; 

1
