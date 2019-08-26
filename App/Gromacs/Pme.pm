package HPC::App::Gromacs::Pme; 

use Moose::Role; 
use HPC::App::Gromacs::Types qw(Tunepme Dlb DDorder); 

has 'tunepme' => (
    is        => 'rw',
    isa       => Tunepme,
    coerce    => 1,
    writer    => 'set_tunepme',
    predicate => 'has_tunepme',
    default   => 0,
);

has 'dlb' => (
    is        => 'rw',
    isa       => Dlb,
    coerce    => 1,
    writer    => 'set_dlb',
    predicate => 'has_dlb',
    default   => 'auto',
);

has 'ddorder' => (
    is        => 'rw',
    isa       => DDorder,
    coerce    => 1,
    writer    => 'set_ddorder',
    predicate => 'has_ddorder',
    default   => 'interleave'
);

1 
