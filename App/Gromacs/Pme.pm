package HPC::App::Gromacs::Pme; 

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs qw(Npme Tunepme); 

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
    default   => 1,
);

1 
