package HPC::Types::Sched::Ime;  

use MooseX::Types::Moose 'HashRef'; 
use MooseX::Types -declare => [qw(Ime_Stage Ime_Sync)]; 

use HPC::Ime::Stage; 
use HPC::Ime::Sync; 

class_type Ime_Stage, { class => 'HPC::Ime::Stage' }; 
class_type Ime_Sync,  { class => 'HPC::Ime::Sync'  }; 

coerce Ime_Stage, from HashRef, via { HPC::Ime::Stage->new($_->%*) }; 
coerce Ime_Sync,  from HashRef, via { HPC::Ime::Sync->new($_->%*)  }; 

1
