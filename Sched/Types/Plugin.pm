package HPC::Sched::Types::Plugin;  

use MooseX::Types::Moose qw(Str HashRef Undef); 
use MooseX::Types -declare => [qw(Aps Numa Lammps Gromacs Qe Tensorflow)]; 

class_type Aps       , { class => 'HPC::Plugin::Aps'        }; 
class_type Numa      , { class => 'HPC::Plugin::Numa'       }; 
class_type Qe        , { class => 'HPC::Plugin::Qe'         }; 
class_type Lammps    , { class => 'HPC::Plugin::Lammps'     }; 
class_type Gromacs   , { class => 'HPC::Plugin::Gromacs'    }; 
class_type Tensorflow, { class => 'HPC::Plugin::Tensorflow' }; 

coerce Aps       , from HashRef, via { HPC::Plugin::Aps->new($_->%*)        }; 
coerce Numa      , from HashRef, via { HPC::Plugin::Numa->new($_->%*)       }; 
coerce Qe        , from HashRef, via { HPC::Plugin::Qe->new($_->%*)         };
coerce Lammps    , from HashRef, via { HPC::Plugin::Lammps->new($_->%*)     }; 
coerce Gromacs   , from HashRef, via { HPC::Plugin::Gromacs->new($_->%*)    };
coerce Tensorflow, from HashRef, via { HPC::Plugin::Tensorflow->new($_->%*) };

1; 
