package HPC::Types::Mpi::Openmpi; 

use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Report Map Bind Env Mca)]; 

subtype Report, as   Str, where { /-report-bindings/ }; 
coerce  Report, from Int, via   { '-report-bindings' }; 

subtype Bind, as   Str, where { /-bind-to/    }; 
coerce  Bind, from Str, via   { "-bind-to $_" }; 

subtype Map, as   Str, where { /-map-by/    }; 
coerce  Map, from Str, via   { "-map-by $_" }; 

subtype Env, as   ArrayRef; 
coerce  Env, from HashRef, via { [map { '-x '.$_.'='.$_[0]->{$_} } sort keys $_[0]->%*] }; 

subtype Mca, as   ArrayRef; 
coerce  Mca, from HashRef, via { [map { '-mca '.$_.'='.$_[0]->{$_} } sort keys $_[0]->%*] }; 

1
