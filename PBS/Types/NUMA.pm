package HPC::PBS::Types::NUMA; 

use IO::File; 
use MooseX::Types -declare => [qw(NUMA)];  

class_type NUMA, { class => 'HPC::NUMA::HBW' }; 

1
