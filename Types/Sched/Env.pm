package HPC::Types::Sched::Env;  

use MooseX::Types::Moose qw(Str ArrayRef);  
use MooseX::Types -declare => [qw(Path Library_Path)]; 

subtype Path,         as Str; 
subtype Library_Path, as Str; 

coerce Path,         from ArrayRef, via { 'PATH='           .join(':', $_->@*, '$PATH')            }; 
coerce Library_Path, from ArrayRef, via { 'LD_LIBRARY_PATH='.join(':', $_->@*, '$LD_LIBRARY_PATH') }; 

1
