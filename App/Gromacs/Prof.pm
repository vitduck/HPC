package HPC::App::Gromacs::Prof;  

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Nsteps Resetstep Resethway); 

has 'nsteps' => (
    is        => 'rw', 
    isa       => Nsteps, 
    coerce    => 1,
    reader    => 'get_nsteps',
    writer    => 'set_nsteps',
    predicate => '_has_nsteps', 
    default   => 1000, 
); 

has 'resetstep' => (
    is        => 'rw', 
    isa       => Resetstep, 
    coerce    => 1,
    lazy      => 1, 
    reader    => 'get_resetstep',
    writer    => 'set_resetstep',
    predicate => '_has_resetstep', 
    default   => 0, 
); 

has 'resethway' => (
    is        => 'rw', 
    isa       => Resethway, 
    coerce    => 1,
    lazy      => 1, 
    reader    => 'get_resethway',
    writer    => 'set_resethway', 
    predicate => '_has_resethway', 
    default   => 0, 
); 

1 
