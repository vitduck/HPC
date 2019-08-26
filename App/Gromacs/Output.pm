package HPC::App::Gromacs::Output; 

use Moose::Role; 
use HPC::App::Gromacs::Types qw(Verbose Deffnm Log Confout); 

has 'verbose' => ( 
    is        => 'rw', 
    isa       => Verbose, 
    coerce    => 1,
    writer    => 'set_verbose',
    predicate => 'has_verbose', 
    default   => 1, 
); 

has 'deffnm' => ( 
    is        => 'rw', 
    isa       => Deffnm, 
    coerce    => 1, 
    lazy      => 1, 
    predicate => 'has_deffnm',
    writer    => 'set_deffnm', 
    default   => 'md'
); 

has 'log' => ( 
    is        => 'rw', 
    isa       => Log, 
    coerce    => 1, 
    lazy      => 1,
    writer    => 'set_log', 
    predicate => 'has_log', 
    default   => 'md.log'
); 

has 'confout' => ( 
    is        => 'rw', 
    isa       => Confout, 
    coerce    => 1,
    writer    => 'set_confout', 
    predicate => 'has_confout', 
    default   => 0,
); 

1 
