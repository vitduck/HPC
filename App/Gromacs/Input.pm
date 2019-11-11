package HPC::App::Gromacs::Input; 

use Moose::Role; 
use MooseX::Attribute::Chained; 
use HPC::App::Types::Gromacs qw(Tpr); 

has 'tpr' => (
    is        => 'rw',
    isa       => Tpr,
    traits    => ['Chained'], 
    predicate => '_has_tpr',
    coerce    => 1,
);

1 
