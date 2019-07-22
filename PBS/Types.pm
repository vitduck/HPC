package HPC::PBS::Types; 

use MooseX::Types -declare => [qw/FH/];  
use MooseX::Types::Moose qw/Str FileHandle/;  
use IO::File; 

subtype FH, 
    as FileHandle; 

coerce FH, 
    from Str, 
    via { return IO::File->new($_, 'w') }; 

1
