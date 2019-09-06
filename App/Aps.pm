package HPC::App::Aps; 

use Moose;  
use MooseX::Types::Moose qw(Str); 
use HPC::App::Types::Aps qw(Type Level Report); 
use Text::Tabs; 
use namespace::autoclean; 

with qw(HPC::App::Base); 

has 'type' => ( 
    is        => 'rw', 
    isa       => Type,
    coerce    => 1, 
    predicate => 'has_type',
    reader    => 'get_type',
    writer    => 'set_type',
); 

has 'level' => (
    is        => 'rw', 
    isa       => Level, 
    coerce    => 1, 
    lazy      => 1, 
    default   => 1,
    predicate => 'has_level', 
    reader    => 'get_level',
    writer    => 'set_level', 
); 

has 'report' => ( 
    is        => 'rw', 
    isa       => Report, 
    coerce    => 1, 
    predicate => 'has_report', 
    reader    => 'get_report',
    writer    => 'set_report',
); 

sub cmd { 
    my $self = shift; 
    my @opts = ();  
    $tabstop = 4; 

    push @opts, $self->report if $self->has_report; 
    return ['aps', expand(map "\t".$_, @opts)]
} 

__PACKAGE__->meta->make_immutable;

1
