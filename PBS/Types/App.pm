package HPC::PBS::Types::App; 

use MooseX::Types -declare => [qw(Aps Numa Lammps Gromacs Qe)]; 
use MooseX::Types::Moose qw(Str HashRef Undef); 

class_type Aps    , { class => 'HPC::App::Aps'     }; 
class_type Numa   , { class => 'HPC::App::Numa'    }; 
class_type Qe     , { class => 'HPC::App::Qe'      }; 
class_type Lammps , { class => 'HPC::App::Lammps'  }; 
class_type Gromacs, { class => 'HPC::App::Gromacs' }; 

coerce Aps    , from HashRef, via { HPC::App::Aps->new($_->%*)     }; 
coerce Numa   , from HashRef, via { HPC::App::Numa->new($_->%*)    }; 
coerce Qe     , from HashRef, via { HPC::App::Qe->new($_->%*)      };
coerce Lammps , from HashRef, via { HPC::App::Lammps->new($_->%*)  }; 
coerce Gromacs, from HashRef, via { HPC::App::Gromacs->new($_->%*) };

1; 
