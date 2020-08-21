package HPC::App::Gromacs::Nb; 

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs qw(Nb); 

has 'nb' => (
    is        => 'rw',
    isa       => Nb,
    traits    => ['Chained'], 
    predicate => '_has_nb',
    coerce    => 1,
    lazy      => 1, 
    default   => 'auto',
);

1 
