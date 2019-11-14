package HPC::Sched::Types::Export; 

use MooseX::Types::Moose qw//; 
use MooseX::Types -declare => [qw(FH_Read FH_Write)]; 

use IO::File; 

subtype FH_Read , as FileHandle; 
subtype FH_Write, as FileHandle; 

coerce FH_Read , from Str, via { IO::File->new($_ => 'r') }; 
coerce FH_Write, from Str, via { IO::File->new($_ => 'w') }; 

1
