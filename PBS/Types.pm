package HPC::PBS::Types; 

use IO::File; 
use MooseX::Types -declare => [qw(FH NUMA)];  
use MooseX::Types::Moose qw(Str FileHandle);  

subtype FH, 
    as FileHandle; 

coerce  FH, 
    from Str, 
    via { IO::File->new($_, 'w') }; 

subtype NUMA, 
    as Str, 
    where { /^numactl/ }; 

coerce NUMA, 
    from Str, 
    via {
        my ($mode, $numa) = split ' ', $_; 

        return join(' ', 'numactl', '-'.$mode, $numa);  
    }; 

1
