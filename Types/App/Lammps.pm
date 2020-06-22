package HPC::Types::App::Lammps; 

use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);
use MooseX::Types -declare => [ 
    qw( Inp Log Suffix Kokkos_Thr Var Pkg 
        Pkg_Opt Pkg_Omp Pkg_Kokkos Pkg_Intel Pkg_Gpu
    ) 
]; 

class_type Pkg_Opt, 
    { class => 'HPC::App::Lammps::Opt' };
coerce Pkg_Opt,   
    from HashRef, 
    via { HPC::App::Lammps::Opt->new($_->%*) }; 

class_type Pkg_Omp, 
    { class => 'HPC::App::Lammps::Omp' };
coerce Pkg_Omp, 
    from HashRef, 
    via { HPC::App::Lammps::Omp->new($_->%*) }; 

class_type Pkg_Gpu, 
    { class => 'HPC::App::Lammps::Gpu' };
coerce Pkg_Gpu, 
    from HashRef, 
    via { HPC::App::Lammps::Gpu->new($_->%*) }; 

class_type Pkg_Intel, 
    { class => 'HPC::App::Lammps::Intel' };
coerce Pkg_Intel, 
    from HashRef, 
    via { HPC::App::Lammps::Intel->new($_->%*) }; 

class_type Pkg_Kokkos, 
    { class => 'HPC::App::Lammps::Kokkos' };
coerce Pkg_Kokkos, 
    from HashRef, 
    via { HPC::App::Lammps::Kokkos->new($_->%*) }; 

subtype Inp, 
    as Str, 
    where { /^\-i/ }; 
coerce Inp, 
    from Str, 
    via { '-i ' .$_ }; 

subtype Suffix, 
    as Str, 
    where { /^\-sf/ }; 
coerce Suffix, 
    from Str, 
    via { '-sf '.$_ }; 

subtype Pkg, 
    as Str, 
    where { /^\-pk|^$/ }; 
coerce  Pkg, 
    from ArrayRef, 
    via { $_->@* ? join ' ', '-pk', $_->@* : '' }; 

subtype Log, 
    as Str, 
    where { /^\-l/ }; 
coerce Log, 
    from Str, 
    via { '-l '.$_ }; 

subtype Kokkos_Thr, 
    as Str, 
    where { /^\-k/ }; 
coerce  Kokkos_Thr, 
    from Int, 
    via { '-k on t '.$_ }; 

subtype Var, 
    as ArrayRef; 
coerce Var, 
    from HashRef, 
    via { [ map join(' ', '-v', $_, $_[0]->{$_}), sort keys $_[0]->%* ] }; 

1
