package HPC::App::Gromacs::Prof;  

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs qw(Nsteps Resetstep Resethway); 

has 'nsteps' => (
    is        => 'rw', 
    isa       => Nsteps, 
    traits    => ['Chained'],
    predicate => '_has_nsteps', 
    coerce    => 1,
    default   => 1000, 
); 

has 'resetstep' => (
    is        => 'rw', 
    isa       => Resetstep, 
    traits    => ['Chained'],
    predicate => '_has_resetstep', 
    coerce    => 1,
    lazy      => 1, 
    default   => 0, 
); 

has 'resethway' => (
    is        => 'rw', 
    isa       => Resethway, 
    traits    => ['Chained'],
    predicate => '_has_resethway', 
    clearer   => '_unset_resethway',
    coerce    => 1,
    lazy      => 1, 
    default   => 0, 
); 

1 
