package HPC::PBS::Types::App; 

use MooseX::Types -declare => [qw(Aps Numa Gromacs)]; 
use MooseX::Types::Moose qw(Str HashRef Undef); 

class_type Aps,     { class => 'HPC::App::Aps'     }; 
class_type Numa,    { class => 'HPC::App::Numa'    }; 
class_type Gromacs, { class => 'HPC::App::Gromacs' }; 

1; 
