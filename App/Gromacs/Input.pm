package HPC::App::Gromacs::Input; 

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Tpr); 

has 'tpr' => (
    is        => 'rw',
    isa       => Tpr,
    coerce    => 1,
    predicate => '_has_tpr',
    writer    => 'set_tpr'
);

1 
