package HPC::Types::App::Lammps; 

use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);
use MooseX::Types -declare => [ qw(
    Inp Log Suffix Kokkos_Thr Var Pkg 
    Pkg_Opt Pkg_Omp Pkg_Kokkos Pkg_Intel Pkg_Gpu) 
]; 

class_type Pkg_Opt,    { class => 'HPC::App::Lammps::Opt'    }; 
class_type Pkg_Omp,    { class => 'HPC::App::Lammps::Omp'    }; 
class_type Pkg_Gpu,    { class => 'HPC::App::Lammps::Gpu'    }; 
class_type Pkg_Intel,  { class => 'HPC::App::Lammps::Intel'  }; 
class_type Pkg_Kokkos, { class => 'HPC::App::Lammps::Kokkos' }; 

subtype Inp,        as Str, where { /^\-i/     }; 
subtype Suffix,     as Str, where { /^\-sf/    }; 
subtype Pkg,        as Str, where { /^\-pk|^$/ }; 
subtype Log,        as Str, where { /^\-l/     }; 
subtype Kokkos_Thr, as Str, where { /^\-k/     }; 
subtype Var,        as Str, where { /^\-v/     }; 

coerce Pkg_Opt,    from HashRef,  via { HPC::App::Lammps::Opt->new($_->%*)    }; 
coerce Pkg_Omp,    from HashRef,  via { HPC::App::Lammps::Omp->new($_->%*)    }; 
coerce Pkg_Gpu,    from HashRef,  via { HPC::App::Lammps::Gpu->new($_->%*)    }; 
coerce Pkg_Intel,  from HashRef,  via { HPC::App::Lammps::Intel->new($_->%*)  }; 
coerce Pkg_Kokkos, from HashRef,  via { HPC::App::Lammps::Kokkos->new($_->%*) }; 
coerce Inp,        from Str,      via { '-i ' .$_                             }; 
coerce Suffix,     from Str,      via { '-sf '.$_                             }; 
coerce Pkg,        from ArrayRef, via { $_->@* ? join ' ', '-pk', $_->@* : '' }; 
coerce Log,        from Str,      via { '-l '.$_                              }; 
coerce Kokkos_Thr, from Int,      via { '-k on t '.$_                         }; 
coerce Var,        from ArrayRef, via { 
    my @vars = ();

    while ( my ($key, $value) = splice $_->@*, 0, 2 ) { 
        push @vars, '-v', $key, $value; 
    } 

    join(' ', @vars) 
}; 

1
