package HPC::Plugin::Types::IMPI; 

use IO::File;
use MooseX::Types::Moose qw(ArrayRef HashRef);  
use MooseX::Types -declare => ['ENV_IMPI']; 

subtype ENV_IMPI, as   ArrayRef; 
coerce  ENV_IMPI, from  HashRef, via { [map '-env '.$_.'='.$_[0]->{$_}, sort keys $_[0]->%*] }; 

1
