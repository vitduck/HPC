package HPC::Plugin::Gromacs::Output; 

use Moose::Role; 
use MooseX::Attribute::Chained; 
use HPC::Plugin::Types::Gromacs qw(Verbose Deffnm Log Confout); 

has 'verbose' => ( 
    is        => 'rw', 
    isa       => Verbose, 
    traits    => ['Chained'], 
    predicate => '_has_verbose', 
    default   => 1, 
    coerce    => 1,
); 

has 'deffnm' => ( 
    is        => 'rw', 
    isa       => Deffnm, 
    traits    => ['Chained'], 
    predicate => '_has_deffnm',
    coerce    => 1, 
    lazy      => 1, 
    default   => 'md'
); 

has 'log' => ( 
    is        => 'rw', 
    isa       => Log, 
    traits    => ['Chained'], 
    predicate => '_has_log', 
    coerce    => 1, 
    lazy      => 1,
    default   => 'md.log', 
); 

has 'confout' => ( 
    is        => 'rw', 
    isa       => Confout, 
    traits    => ['Chained'], 
    predicate => '_has_confout', 
    coerce    => 1,
    default   => 0,
); 

1 
