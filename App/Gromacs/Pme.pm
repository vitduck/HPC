package HPC::App::Gromacs::Pme; 

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Tunepme Dlb DDorder); 

has 'tunepme' => (
    is        => 'rw',
    isa       => Tunepme,
    coerce    => 1,
    predicate => '_has_tunepme',
    writer    => 'set_tunepme',
    default   => 0,
);

has 'dlb' => (
    is        => 'rw',
    isa       => Dlb,
    coerce    => 1,
    predicate => '_has_dlb',
    writer    => 'set_dlb',
    default   => 'auto',
);

has 'ddorder' => (
    is        => 'rw',
    isa       => DDorder,
    coerce    => 1,
    lazy      => 1,
    predicate => '_has_ddorder',
    writer    => 'set_ddorder',
    default   => 'interleave', 
);

1 
