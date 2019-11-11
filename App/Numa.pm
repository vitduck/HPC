package HPC::App::Numa; 

use Moose;  
use MooseX::XSAccessor; 
use HPC::App::Types::Numa qw(Membind Preferred);  

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data );  

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
    default   => 'mcdram' 
); 

has 'preferred' => ( 
    is        => 'rw', 
    isa       => Preferred,
    traits    => ['Chained'],
    predicate => '_has_preferred', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 'mcdram',
); 

sub _get_opts { 
    return qw(membind preferred)
} 

__PACKAGE__->meta->make_immutable;

1
