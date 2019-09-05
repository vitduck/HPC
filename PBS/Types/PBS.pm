package HPC::PBS::Types::PBS; 

use MooseX::Types -declare => [qw(Shell Export Project Account Queue Name Resource Walltime Stderr Stdout)]; 
use MooseX::Types::Moose qw(Str Bool ArrayRef); 

subtype Shell   , as Str, where { /^#!/   }; 
subtype Export  , as Str, where { /^#PBS/ }; 
subtype Project , as Str, where { /^#PBS/ }; 
subtype Account , as Str, where { /^#PBS/ }; 
subtype Queue   , as Str, where { /^#PBS/ }; 
subtype Name    , as Str, where { /^#PBS/ }; 
subtype Resource, as Str, where { /^#PBS/ }; 
subtype Walltime, as Str, where { /^#PBS/ }; 
subtype Stdout  , as Str, where { /^#PBS/ }; 
subtype Stderr  , as Str, where { /^#PBS/ }; 

coerce Shell   , from Str      , via { "#!/usr/bin/env $_" };
coerce Export  , from Bool     , via { '#PBS -V' }; 
coerce Project , from Str      , via { "#PBS -P $_" };
coerce Account , from Str      , via { "#PBS -A $_" };  
coerce Queue   , from Str      , via { "#PBS -q $_" }; 
coerce Name    , from Str      , via { "#PBS -N $_" }; 
coerce Resource, from ArrayRef , via { "#PBS -l ".join(':', $_->@*) }; 
coerce Walltime, from Str      , via { "#PBS -l walltime=$_" }; 
coerce Stdout  , from Str      , via { "#PBS -o $_" }; 
coerce Stderr  , from Str      , via { "#PBS -e $_" }; 
 
1; 
