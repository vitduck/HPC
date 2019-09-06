package HPC::App::Types::Lammps; 

use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);
use MooseX::Types -declare => [ qw(
    Inp Log Suffix Kokkos_OMP Var Pkg 
    Nthread Nphi Ngpu
    OPT OMP KOKKOS INTEL GPU) 
]; 

class_type OPT     , { class => 'HPC::App::Lammps::Opt'    }; 
class_type OMP     , { class => 'HPC::App::Lammps::Omp'    }; 
class_type GPU     , { class => 'HPC::App::Lammps::Gpu'    }; 
class_type INTEL   , { class => 'HPC::App::Lammps::Intel'  }; 
class_type KOKKOS  , { class => 'HPC::App::Lammps::Kokkos' }; 
subtype Nthread    , as Str, where { /omp/      }; 
subtype Nphi       , as Str, where { /intel/    }; 
subtype Ngpu       , as Str, where { /gpu/      }; 
subtype Inp        , as Str, where { /^\-i/     }; 
subtype Suffix     , as Str, where { /^\-sf/    }; 
subtype Pkg        , as Str; where { /^\-pk|^$/ }; 
subtype Log        , as Str, where { /^\-l/     }; 
subtype Kokkos_OMP , as Str, where { /^\-k/     }; 
subtype Var        , as Str, where { /^\-v/     }; 

coerce OPT       , from HashRef,  via { HPC::App::Lammps::Opt->new($_->%*)    }; 
coerce OMP       , from HashRef,  via { HPC::App::Lammps::Omp->new($_->%*)    }; 
coerce GPU       , from HashRef,  via { HPC::App::Lammps::Gpu->new($_->%*)    }; 
coerce INTEL     , from HashRef,  via { HPC::App::Lammps::Intel->new($_->%*)  }; 
coerce KOKKOS    , from HashRef,  via { HPC::App::Lammps::Kokkos->new($_->%*) }; 
coerce Nthread   , from Int,      via { "omp $_"                              };    
coerce Nphi      , from Int,      via { "intel $_"                            };    
coerce Ngpu      , from Int,      via { "gpu $_"                              };    
coerce Inp       , from Str,      via { '-i ' .$_                             }; 
coerce Suffix    , from Str,      via { '-sf '.$_                             }; 
coerce Pkg       , from ArrayRef, via { $_->@* ? join ' ', '-pk', $_->@* : '' }; 
coerce Log       , from Str,      via { '-l '.$_                              }; 
coerce Kokkos_OMP, from Int,      via { '-k on t '.$_                         }; 
coerce Var       , from ArrayRef, via { 
                                        my @vars = ();

                                        while ( my ($key, $value) = splice $_->@*, 0, 2 ) { 
                                            push @vars, '-v', $key, $value; 
                                        } 

                                        join(' ', @vars) 
                                    }; 

1
