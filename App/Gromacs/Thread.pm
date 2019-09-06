package HPC::App::Gromacs::Thread;  

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Nt Ntmpi Ntomp); 

has 'nt' => (
    is        => 'rw',
    isa       => Nt,
    coerce    => 1,
    lazy      => 1, 
    predicate => '_has_nt',
    writer    => 'set_nt',
    default   => 1,
);

has 'ntmpi' => (
    is        => 'rw',
    isa       => Ntmpi,
    coerce    => 1,
    lazy      => 1,
    predicate => '_has_ntmpi',
    writer    => 'set_ntmpi',
    default   => 1,
);

has 'ntomp' => (
    is        => 'rw',
    isa       => Ntomp,
    coerce    => 1,
    lazy      => 1,
    predicate => '_has_ntomp',
    writer    => 'set_ntomp',
    default   => 1,
);

1 
