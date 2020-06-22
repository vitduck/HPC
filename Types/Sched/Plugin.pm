package HPC::Types::Sched::Plugin; 

use MooseX::Types::Moose qw(Str HashRef ArrayRef); 
use MooseX::Types -declare => [
    qw( Aps Numa 
        Lammps Gromacs Qe Vasp Tensorflow
        Iterator 
    )
]; 

class_type Aps, 
    { class => 'HPC::Profile::Aps' }; 
coerce Aps, 
    from HashRef, 
    via { HPC::Profile::Aps->new($_) }; 

class_type Numa, 
    { class => 'HPC::Profile::Numa' }; 
coerce Numa, 
    from HashRef, 
    via { HPC::Profile::Numa->new($_) }; 

class_type Qe, 
    { class => 'HPC::App::Qe' }; 
coerce Qe, 
    from HashRef,  
    via { HPC::App::Qe->new($_) };

class_type Vasp, 
    { class => 'HPC::App::Vasp' }; 
coerce Vasp, 
    from HashRef,  
    via { HPC::App::Vasp->new($_) };

class_type Lammps, 
    { class => 'HPC::App::Lammps' }; 
coerce Lammps, 
    from HashRef,  
    via { HPC::App::Lammps->new($_) }; 

class_type Gromacs   , 
    { class => 'HPC::App::Gromacs' }; 
coerce Gromacs, 
    from HashRef,  
    via { HPC::App::Gromacs->new($_) };

class_type Tensorflow, 
    { class => 'HPC::App::Tensorflow' }; 
coerce Tensorflow, 
    from HashRef,  
    via { HPC::App::Tensorflow->new($_) };

class_type Iterator, 
    { class => 'HPC::Sched::Iterator' };  
coerce Iterator, 
    from ArrayRef, 
    via { HPC::Sched::Iterator->new($_) }; 

1; 
