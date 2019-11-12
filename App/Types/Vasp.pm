package HPC::App::Types::Vasp; 

use MooseX::Types::Moose qw/Str FileHandle/; 
use MooseX::Types -declare => [qw(IO_Read IO_Write)]; 

use IO::File; 

subtype IO_Read , as FileHandle; 
subtype IO_Write, as FileHandle; 

coerce IO_Read , from Str, via { IO::File->new($_ => 'r') }; 
coerce IO_Write, from Str, via { IO::File->new($_ => 'w') }; 

1
