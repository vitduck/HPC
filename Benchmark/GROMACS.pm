package HPC::Benchmark::GROMACS; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw(Int Str);  
use HPC::App::GROMACS::Types qw(Tpr Log Deffnm Verbose Tunepme Dlb Nsteps Resetstep Resethway Confout); 
use namespace::autoclean; 

with qw(HPC::Debug::Data HPC::Benchmark::Base);  

has 'tpr' => ( 
    is        => 'rw', 
    isa       => Tpr, 
    coerce    => 1, 
    required  => 1, 
    predicate => 'has_tpr',
    writer    => 'set_tpr'
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

has 'verbose' => ( 
    is        => 'rw', 
    isa       => Verbose, 
    coerce    => 1,
    writer    => 'set_verbose',
    predicate => 'has_verbose', 
    default   => 1, 
); 

has 'tunepme' => ( 
    is        => 'rw', 
    isa       => Tunepme,
    coerce    => 1, 
    writer    => 'set_tunepme',
    predicate => 'has_tunepme', 
    default   => 0, 
);  

has 'dlb' => ( 
    is        => 'rw', 
    isa       => Dlb,
    coerce    => 1,
    writer    => 'set_dlb',
    predicate => 'has_dlb', 
    default   => 'auto', 
); 

has 'nsteps' => (  
    is        => 'rw', 
    isa       => Nsteps, 
    coerce    => 1,
    writer    => 'set_nsteps',
    predicate => 'has_nsteps', 
    default   => 1000, 
); 

has 'resetstep' => (  
    is        => 'rw', 
    isa       => Resetstep, 
    coerce    => 1,
    lazy      => 1, 
    writer    => 'set_resetstep',
    predicate => 'has_resetstep', 
    default   => 0, 
); 

has 'resethway' => (  
    is        => 'rw', 
    isa       => Resethway, 
    coerce    => 1,
    lazy      => 1, 
    writer    => 'set_resethway', 
    predicate => 'has_resethway', 
    default   => 0, 
); 

has 'confout' => ( 
    is        => 'rw', 
    isa       => Confout, 
    coerce    => 1,
    lazy      => 1, 
    writer    => 'set_confout', 
    predicate => 'has_confout', 
    default   => 0,
); 

sub cmd { 
    my $self = shift; 

    my @opts = ($self->bin);  
    my @atrs = qw(verbose tunepme dlb nsteps resetstep resethway confout tpr log deffnm); 

    for my $atr (@atrs) { 
        my $predicate = "has_$atr"; 
        
        push @opts, $self->$atr if $self->$predicate; 
    } 

    join(' ', @opts); 
} 

__PACKAGE__->meta->make_immutable;

1
