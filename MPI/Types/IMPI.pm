package HPC::MPI::Types::IMPI; 

use IO::File;
use MooseX::Types::Moose qw(ArrayRef HashRef);  
use MooseX::Types -declare => ['ENV_IMPI']; 

subtype ENV_IMPI, as   ArrayRef; 
coerce  ENV_IMPI, from HashRef, via { my $env = shift; [map '-env '.$_.'='.$env->{$_}, sort keys $env->%*] }; 

1
