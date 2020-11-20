package HPC::App::Gromacs::Tasks; 

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs qw(Nb Bonded Pme Update Dlb); 

has 'nb' => (
    is        => 'rw',
    isa       => Nb,
    traits    => ['Chained'], 
    predicate => '_has_nb',
    coerce    => 1,
    default   => 'auto',
);

has 'bonded' => (
    is        => 'rw',
    isa       => Bonded,
    traits    => ['Chained'], 
    predicate => '_has_bonded',
    coerce    => 1,
    default   => 'auto',
);

has 'pme' => (
    is        => 'rw',
    isa       => Pme,
    traits    => ['Chained'],
    predicate => '_has_pme',
    coerce    => 1,
    lazy      => 1,
    default   => 'auto',
);

has 'update' => (
    is        => 'rw',
    isa       => Update,
    traits    => ['Chained'],
    predicate => '_has_update',
    coerce    => 1,
    lazy      => 1,
    default   => 'auto',

); 

has 'dlb' => (
    is        => 'rw',
    isa       => Dlb,
    traits    => ['Chained'], 
    predicate => '_has_dlb',
    coerce    => 1,
    default   => 'auto',
);

1 
