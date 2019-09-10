package HPC::App::Aps; 

use Moose;  
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw(Str); 
use HPC::App::Types::Aps qw(Type Level Report); 
use namespace::autoclean; 

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data
);

has '+bin' => (
    default => 'aps'
);

has 'type' => ( 
    is        => 'rw', 
    isa       => Type,
    coerce    => 1, 
    reader    => 'get_type',
    writer    => 'set_type',
    predicate => '_has_type',
    lazy      => 1, 
    default   => 1, 
); 

has 'level' => (
    is        => 'rw', 
    isa       => Level, 
    coerce    => 1, 
    reader    => 'get_level',
    writer    => 'set_level', 
    predicate => '_has_level', 
    lazy      => 1, 
    default   => 1,
); 

has 'report' => ( 
    is        => 'rw', 
    isa       => Report, 
    coerce    => 1, 
    reader    => 'get_report',
    writer    => 'set_report',
    predicate => '_has_report', 
);

sub _get_opts {
    return (qw(report))
} 

__PACKAGE__->meta->make_immutable;

1
