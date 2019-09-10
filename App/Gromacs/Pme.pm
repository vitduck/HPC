package HPC::App::Gromacs::Pme; 

use Moose::Role; 
use MooseX::Attribute::Chained; 
use HPC::App::Types::Gromacs qw(Tunepme Dlb DDorder); 

has 'tunepme' => (
    is        => 'rw',
    isa       => Tunepme,
    coerce    => 1,
    traits    => ['Chained'], 
    predicate => '_has_tunepme',
    default   => 0,
);

has 'dlb' => (
    is        => 'rw',
    isa       => Dlb,
    coerce    => 1,
    traits    => ['Chained'], 
    predicate => '_has_dlb',
    default   => 'auto',
);

has 'ddorder' => (
    is        => 'rw',
    isa       => DDorder,
    coerce    => 1,
    traits    => ['Chained'], 
    lazy      => 1,
    predicate => '_has_ddorder',
    default   => 'interleave', 
);

1 
