package HPC::App::Gromacs::Prof;  

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Nsteps Resetstep Resethway); 

has 'nsteps' => (  
    is        => 'rw', 
    isa       => Nsteps, 
    coerce    => 1,
    predicate => '_has_nsteps', 
    writer    => 'set_nsteps',
    default   => 1000, 
); 

has 'resetstep' => (  
    is        => 'rw', 
    isa       => Resetstep, 
    coerce    => 1,
    lazy      => 1, 
    predicate => '_has_resetstep', 
    writer    => 'set_resetstep',
    default   => 0, 
); 

has 'resethway' => (  
    is        => 'rw', 
    isa       => Resethway, 
    coerce    => 1,
    lazy      => 1, 
    predicate => '_has_resethway', 
    writer    => 'set_resethway', 
    default   => 0, 
); 

1 
