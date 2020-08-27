package HPC::Types::Mpi::Impi;

use MooseX::Types::Moose qw(ArrayRef HashRef Str);  
use MooseX::Types -declare => ['Env']; 
use IO::File;

subtype Env, as   ArrayRef; 
coerce  Env, from HashRef, via { [map { '-env '.$_.'='.$_[0]->{$_} } sort keys $_[0]->%*] }; 

1
