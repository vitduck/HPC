package HPC::App::Gromacs::Types; 

use MooseX::Types::Moose qw/Str Int/; 

use MooseX::Types -declare => [qw(
    Verbose Tpr Deffnm Log Confout 
    Nt Ntmpi Ntomp
    Tunepme Dlb DDorder 
    Nsteps Resetstep Resethway)]; 

subtype Verbose,   as Str, where { /^\-v|^$/         }; 
subtype Tpr,       as Str, where { /^\-s/            }; 
subtype Deffnm,    as Str, where { /^\-deffnm/       }; 
subtype Log,       as Str, where { /^\-g/            }; 
subtype Confout,   as Str, where { /^\-noconfout|^$/ };  
subtype Nt,        as Str, where { /^\-nt/           };  
subtype Ntmpi,     as Str, where { /^\-ntmpi/        };  
subtype Ntomp,     as Str, where { /^\-ntomp/        };  
subtype Tunepme,   as Str, where { /^\-notunepme|^$/ }; 
subtype Dlb,       as Str, where { /^\-dlb/          };  
subtype DDorder,   as Str, where { /^\-ddorder/      };  
subtype Nsteps,    as Str, where { /^\-nsteps/       };  
subtype Resetstep, as Str, where { /^\-resetstep/    };  
subtype Resethway, as Str, where { /^\-resethway|^$/ };  

coerce Verbose,    from Int, via { $_ ? '-v': ''          }; 
coerce Tpr,        from Str, via { '-s '.$_               }; 
coerce Deffnm,     from Str, via { '-deffnm '.$_          }; 
coerce Log,        from Str, via { '-g '.$_               }; 
coerce Confout,    from Int, via { $_ ? '' : '-noconfout' }; 
coerce Nt,         from Int, via { '-nt '.$_              }; 
coerce Ntmpi,      from Int, via { '-ntmpi '.$_           }; 
coerce Ntomp,      from Int, via { '-ntomp '.$_           }; 
coerce Tunepme,    from Int, via { $_ ? '' : '-notunepme' }; 
coerce Dlb,        from Str, via { '-dlb '.$_             }; 
coerce DDorder,    from Str, via { '-ddorder '.$_         }; 
coerce Nsteps,     from Int, via { '-nsteps '.$_          }; 
coerce Resetstep,  from Int, via { '-resetstep '.$_       }; 
coerce Resethway,  from Int, via { $_ ? '-resethway' : '' }; 

1
