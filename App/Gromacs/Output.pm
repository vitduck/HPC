package HPC::App::Gromacs::Output; 

use Moose::Role; 
use MooseX::Attribute::Chained; 
use HPC::App::Types::Gromacs qw(Verbose Deffnm Log Confout); 

has 'verbose' => ( 
    is        => 'rw', 
    isa       => Verbose, 
    coerce    => 1,
    traits    => ['Chained'], 
    predicate => '_has_verbose', 
    default   => 1, 
); 

has 'deffnm' => ( 
    is        => 'rw', 
    isa       => Deffnm, 
    coerce    => 1, 
    lazy      => 1, 
    traits    => ['Chained'], 
    predicate => '_has_deffnm',
    default   => 'md'
); 

has 'log' => ( 
    is        => 'rw', 
    isa       => Log, 
    coerce    => 1, 
    lazy      => 1,
    traits    => ['Chained'], 
    predicate => '_has_log', 
    default   => 'md.log'
); 

has 'confout' => ( 
    is        => 'rw', 
    isa       => Confout, 
    coerce    => 1,
    traits    => ['Chained'], 
    predicate => '_has_confout', 
    default   => 0,
); 

1 
