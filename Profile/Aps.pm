package HPC::Profile::Aps; 

use Moose;  
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::Types::Moose 'Str'; 
use MooseX::XSAccessor; 

use HPC::Types::Profile::Aps qw(Type Level Report); 

use experimental 'signatures'; 
use namespace::autoclean; 

with qw(
    HPC::Debug::Dump 
    HPC::Plugin::Cmd ); 

has '+bin' => (
    default => 'aps' 
);

has 'type' => ( 
    is        => 'rw', 
    isa       => Type,
    traits    => ['Chained'],
    predicate => '_has_type',
    reader    => 'get_type',
    coerce    => 1, 
    lazy      => 1, 
    default   => 1 
); 

has 'level' => (
    is        => 'rw', 
    isa       => Level, 
    traits    => ['Chained'],
    predicate => '_has_level', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 1 
); 

has 'report' => ( 
    is        => 'rw', 
    isa       => Report, 
    traits    => ['Chained'],
    predicate => '_has_report', 
    coerce    => 1 
);

sub _opts {
    return (qw(report))
} 

__PACKAGE__->meta->make_immutable;

1
