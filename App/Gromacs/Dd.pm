package HPC::App::Gromacs::Dd; 

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs 'Ddorder'; 

has 'ddorder' => (
    is        => 'rw',
    isa       => Ddorder,
    traits    => ['Chained'], 
    predicate => '_has_ddorder',
    coerce    => 1,
    default   => 'interleave', 
);

1 
