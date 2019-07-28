package HPC::PBS::Types; 

use IO::File; 
use MooseX::Types -declare => [qw/FH/];  
use MooseX::Types::Moose qw/Str FileHandle/;  

subtype FH, 
    as FileHandle; 

coerce  FH, 
    from Str, 
    via { IO::File->new($_, 'w') }; 

1
