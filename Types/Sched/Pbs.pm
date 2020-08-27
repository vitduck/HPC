package HPC::Types::Sched::Pbs; 

use MooseX::Types::Moose qw(Str Bool ArrayRef); 
use MooseX::Types -declare => [qw(Export Project Account Queue Name Walltime Stderr Stdout Resource)]; 

subtype Export, as   Str,  where { /^#PBS/   }; 
coerce  Export, from Bool, via   { '#PBS -V' }; 

subtype Project, as   Str, where { /^#PBS/      }; 
coerce  Project, from Str, via   { "#PBS -P $_" };

subtype Account, as   Str, where { /^#PBS/      }; 
coerce  Account, from Str, via   { "#PBS -A $_" };  

subtype Queue, as   Str, where { /^#PBS/      }; 
coerce  Queue, from Str, via   { "#PBS -q $_" }; 

subtype Name, as   Str, where { /^#PBS/      }; 
coerce  Name, from Str, via   { "#PBS -N $_" }; 

subtype Walltime, as   Str, where { /^#PBS/               }; 
coerce  Walltime, from Str, via   { "#PBS -l walltime=$_" }; 

subtype Stdout, as   Str, where { /^#PBS/      }; 
coerce  Stdout, from Str, via   { "#PBS -o $_" }; 

subtype Stderr, as   Str, where { /^#PBS/      }; 
coerce  Stderr, from Str, via   { "#PBS -e $_" }; 

subtype Resource, as   Str, where { /^#PBS/ }; 
coerce  Resource, from Str,      via { "#PBS -l select=$_"                 },
                  from ArrayRef, via { "#PBS -l select=".join('+', $_->@*) }; 
 
1; 
