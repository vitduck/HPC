package HPC::PBS::Types::Numa; 

use IO::File; 
use MooseX::Types -declare => [qw(Numa)];  
use MooseX::Types::Moose qw(Str);  

subtype Numa,   as Str, where { /^numactl/ }; 
coerce  Numa, from Str,   via { my ($mode, $numa) = split ' ', $_; join(' ', 'numactl', '-'.$mode, $numa) };

1
