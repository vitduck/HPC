package HPC::App::Gromacs::Pme; 

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs qw(Tunepme Dlb DDorder Npme); 

has 'npme' => (
    is        => 'rw',
    isa       => Npme,
    traits    => ['Chained'], 
    predicate => '_has_npme',
    coerce    => 1,
    lazy      => 1, 
    default   => -1,
);

has 'tunepme' => (
    is        => 'rw',
    isa       => Tunepme,
    traits    => ['Chained'], 
    predicate => '_has_tunepme',
    coerce    => 1,
    default   => 0,
);

has 'dlb' => (
    is        => 'rw',
    isa       => Dlb,
    traits    => ['Chained'], 
    predicate => '_has_dlb',
    coerce    => 1,
    default   => 'auto',
);

has 'ddorder' => (
    is        => 'rw',
    isa       => DDorder,
    traits    => ['Chained'], 
    predicate => '_has_ddorder',
    coerce    => 1,
    default   => 'interleave', 
);

1 
