package HPC::Types::Sched::Plugin; 

use MooseX::Types::Moose qw(Str HashRef Undef); 
use MooseX::Types -declare => [qw(Aps Numa Lammps Gromacs Qe Vasp Tensorflow)]; 

class_type Aps,        { class => 'HPC::Profile::Aps'    }; 
class_type Numa,       { class => 'HPC::Profile::Numa'   }; 
class_type Qe,         { class => 'HPC::App::Qe'         }; 
class_type Vasp,       { class => 'HPC::App::Vasp'       }; 
class_type Lammps,     { class => 'HPC::App::Lammps'     }; 
class_type Gromacs,    { class => 'HPC::App::Gromacs'    }; 
class_type Tensorflow, { class => 'HPC::App::Tensorflow' }; 

coerce Aps,        from HashRef, via { HPC::Profile::Aps->new($_->%*)    }; 
coerce Numa,       from HashRef, via { HPC::Profile::Numa->new($_->%*)   }; 
coerce Qe,         from HashRef, via { HPC::App::Qe->new($_->%*)         };
coerce Vasp,       from HashRef, via { HPC::App::Vasp->new($_->%*)       };
coerce Lammps,     from HashRef, via { HPC::App::Lammps->new($_->%*)     }; 
coerce Gromacs,    from HashRef, via { HPC::App::Gromacs->new($_->%*)    };
coerce Tensorflow, from HashRef, via { HPC::App::Tensorflow->new($_->%*) };

1; 
