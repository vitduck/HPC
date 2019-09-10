package HPC::App::Gromacs::Output; 

use Moose::Role; 
use HPC::App::Types::Gromacs qw(Verbose Deffnm Log Confout); 

has 'verbose' => ( 
    is        => 'rw', 
    isa       => Verbose, 
    coerce    => 1,
    reader    => 'get_verbose',
    writer    => 'set_verbose',
    predicate => '_has_verbose', 
    default   => 1, 
); 

has 'deffnm' => ( 
    is        => 'rw', 
    isa       => Deffnm, 
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_deffnm',
    writer    => 'set_deffnm', 
    predicate => '_has_deffnm',
    default   => 'md'
); 

has 'log' => ( 
    is        => 'rw', 
    isa       => Log, 
    coerce    => 1, 
    lazy      => 1,
    reader    => 'get_log', 
    writer    => 'set_log', 
    predicate => '_has_log', 
    default   => 'md.log'
); 

has 'confout' => ( 
    is        => 'rw', 
    isa       => Confout, 
    coerce    => 1,
    reader    => 'get_confout',
    writer    => 'set_confout', 
    predicate => '_has_confout', 
    default   => 0,
); 

1 
