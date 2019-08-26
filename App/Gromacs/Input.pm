package HPC::App::Gromacs::Input; 

use Moose::Role; 
use HPC::App::Gromacs::Types qw(Tpr); 

has 'tpr' => (
    is        => 'rw',
    isa       => Tpr,
    coerce    => 1,
    required  => 1,
    predicate => 'has_tpr',
    writer    => 'set_tpr'
);

1 
