package HPC::Plugin::Gromacs::Input; 

use Moose::Role; 
use MooseX::Attribute::Chained; 
use HPC::Plugin::Types::Gromacs qw(Tpr); 

has 'tpr' => (
    is        => 'rw',
    isa       => Tpr,
    traits    => ['Chained'], 
    predicate => '_has_tpr',
    coerce    => 1,
);

1 
