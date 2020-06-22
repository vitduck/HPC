package HPC::App::Gromacs::Thread;  

use Moose::Role; 
use MooseX::Attribute::Chained; 

use HPC::Types::App::Gromacs qw(Nt Ntmpi Ntomp); 

has 'nt' => (
    is        => 'rw',
    isa       => Nt,
    lazy      => 1, 
    traits    => ['Chained'],
    predicate => '_has_nt',
    coerce    => 1,
    default   => 1,
);

has 'ntmpi' => (
    is        => 'rw',
    isa       => Ntmpi,
    traits    => ['Chained'],
    predicate => '_has_ntmpi',
    coerce    => 1,
    lazy      => 1,
    default   => 1,
);

has 'ntomp' => (
    is        => 'rw',
    isa       => Ntomp,
    traits    => ['Chained'],
    predicate => '_has_ntomp',
    coerce    => 1,
    lazy      => 1,
    default   => 1,
);

1 
