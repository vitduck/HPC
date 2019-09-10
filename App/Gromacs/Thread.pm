package HPC::App::Gromacs::Thread;  

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Nt Ntmpi Ntomp); 

has 'nt' => (
    is        => 'rw',
    isa       => Nt,
    coerce    => 1,
    lazy      => 1, 
    reader    => 'get_nt',
    writer    => 'set_nt',
    predicate => '_has_nt',
    default   => 1,
);

has 'ntmpi' => (
    is        => 'rw',
    isa       => Ntmpi,
    coerce    => 1,
    lazy      => 1,
    reader    => 'get_ntmpi',
    writer    => 'set_ntmpi',
    predicate => '_has_ntmpi',
    default   => 1,
);

has 'ntomp' => (
    is        => 'rw',
    isa       => Ntomp,
    coerce    => 1,
    lazy      => 1,
    reader    => 'get_ntomp',
    writer    => 'set_ntomp',
    predicate => '_has_ntomp',
    default   => 1,
);

1 
