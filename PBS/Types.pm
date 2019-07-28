package HPC::PBS::Types; 

use IO::File; 
use MooseX::Types -declare => [qw/FH MCDRAM DDR4/];  
use MooseX::Types::Moose qw/Str FileHandle/;  

subtype FH, 
    as FileHandle; 

coerce  FH, 
    from Str, 
    via { IO::File->new($_, 'w') }; 

subtype MCDRAM, 
    as Str, 
    where { $_ =~ /^numactl/ }; 

coerce MCDRAM, 
    from Str, 
    via { 
        if    (/m/) { 'numactl -m 1' } 
        elsif (/p/) { 'numaclt -p 1' } 
    }; 

subtype DDR4, 
    as Str, 
    where { $_ =~ /^numactl/ }; 

coerce DDR4, 
    from Str, 
    via { 'numactl -m 0' }; 

1
