package HPC::App::Gromacs::Thread;  

use Moose::Role; 
use HPC::App::Gromacs::Types qw(Nt Ntmpi Ntomp); 

has 'nt' => (
    is        => 'rw',
    isa       => Nt,
    coerce    => 1,
    lazy      => 1, 
    writer    => 'set_nt',
    predicate => 'has_nt',
    default   => 1,
);

has 'ntmpi' => (
    is        => 'rw',
    isa       => Ntmpi,
    coerce    => 1,
    lazy      => 1,
    writer    => 'set_ntmpi',
    predicate => 'has_ntmpi',
    default   => 1,
);

has 'ntomp' => (
    is        => 'rw',
    isa       => Ntomp,
    coerce    => 1,
    lazy      => 1,
    writer    => 'set_ntomp',
    predicate => 'has_ntomp',
    default   => 1,
);

1 
