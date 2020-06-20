package HPC::Types::Sched::Pbs; 

use MooseX::Types::Moose qw(Str Bool ArrayRef); 
use MooseX::Types -declare => [qw(Export Project Account Queue Name Walltime Stderr Stdout Resource)]; 
use Data::Printer;

subtype Export,   as Str, where { /^#PBS/ }; 
subtype Project,  as Str, where { /^#PBS/ }; 
subtype Account,  as Str, where { /^#PBS/ }; 
subtype Queue,    as Str, where { /^#PBS/ }; 
subtype Name,     as Str, where { /^#PBS/ }; 
subtype Walltime, as Str, where { /^#PBS/ }; 
subtype Stdout,   as Str, where { /^#PBS/ }; 
subtype Stderr,   as Str, where { /^#PBS/ }; 
subtype Resource, as Str, where { /^#PBS/ }; 

coerce Export , from Bool,     via { '#PBS -V'                           }; 
coerce Project, from Str,      via { "#PBS -P $_"                        };
coerce Account, from Str,      via { "#PBS -A $_"                        };  
coerce Queue,   from Str,      via { "#PBS -q $_"                        }; 
coerce Name,    from Str,      via { "#PBS -N $_"                        }; 
coerce Walltime,from Str,      via { "#PBS -l walltime=$_"               }; 
coerce Stdout,  from Str,      via { "#PBS -o $_"                        }; 
coerce Stderr,  from Str,      via { "#PBS -e $_"                        }; 
coerce Resource,from Str,      via { "#PBS -l select=$_"                 },
                from ArrayRef, via { "#PBS -l select=".join('+', $_->@*) }; 
 
1; 
