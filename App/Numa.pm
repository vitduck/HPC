package HPC::App::Numa; 

use Moose;  
use MooseX::XSAccessor; 
use HPC::App::Types::Numa qw(Membind Preferred);  

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data
);  

has '+bin' => ( 
    default => 'numactl'
); 

has 'membind' => ( 
    is        => 'rw', 
    isa       => Membind,
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_membind',
    writer    => 'set_membind',
    predicate => '_has_membind', 
    default   => 'mcdram', 
); 

has 'preferred' => ( 
    is        => 'rw', 
    isa       => Preferred,
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_preferred',
    writer    => 'set_preferred',
    predicate => '_has_preferred', 
    default   => 'mcdram',
); 

sub _get_opts { 
    return qw(membind preferred)
} 

__PACKAGE__->meta->make_immutable;

1
