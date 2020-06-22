package HPC::Profile::Numa; 

use Moose;  
use MooseX::Aliases; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::XSAccessor; 

use HPC::Types::Profile::Numa qw(Membind Preferred);  

use namespace::autoclean; 

with qw(
    HPC::Debug::Dump  
    HPC::Plugin::Cmd ); 

has '+bin' => ( 
    default => 'numactl' 
); 

has 'membind' => ( 
    is        => 'rw', 
    isa       => Membind,
    traits    => ['Chained'],
    predicate => '_has_membind', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 'mcdram',  
    alias     => 'm',
); 

has 'preferred' => ( 
    is        => 'rw', 
    isa       => Preferred,
    traits    => ['Chained'],
    predicate => '_has_preferred', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 'mcdram',
    alias     => 'p'
); 

sub _opts { 
    return qw(membind preferred)
} 

__PACKAGE__->meta->make_immutable;

1
