package HPC::App::Gromacs::Pme; 

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Tunepme Dlb DDorder); 

has 'tunepme' => (
    is        => 'rw',
    isa       => Tunepme,
    coerce    => 1,
    reader    => 'get_tunepme',
    writer    => 'set_tunepme',
    predicate => '_has_tunepme',
    default   => 0,
);

has 'dlb' => (
    is        => 'rw',
    isa       => Dlb,
    coerce    => 1,
    reader    => 'get_dlb',
    writer    => 'set_dlb',
    predicate => '_has_dlb',
    default   => 'auto',
);

has 'ddorder' => (
    is        => 'rw',
    isa       => DDorder,
    coerce    => 1,
    lazy      => 1,
    reader    => 'get_ddorder',
    writer    => 'set_ddorder',
    predicate => '_has_ddorder',
    default   => 'interleave', 
);

1 
