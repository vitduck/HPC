package HPC::App::Gromacs::Prof;  

use Moose::Role; 
use HPC::App::Gromacs::Types qw(Nsteps Resetstep Resethway); 

has 'nsteps' => (  
    is        => 'rw', 
    isa       => Nsteps, 
    coerce    => 1,
    writer    => 'set_nsteps',
    predicate => 'has_nsteps', 
    default   => 1000, 
); 

has 'resetstep' => (  
    is        => 'rw', 
    isa       => Resetstep, 
    coerce    => 1,
    lazy      => 1, 
    writer    => 'set_resetstep',
    predicate => 'has_resetstep', 
    default   => 0, 
); 

has 'resethway' => (  
    is        => 'rw', 
    isa       => Resethway, 
    coerce    => 1,
    lazy      => 1, 
    writer    => 'set_resethway', 
    predicate => 'has_resethway', 
    default   => 0, 
); 

1 
