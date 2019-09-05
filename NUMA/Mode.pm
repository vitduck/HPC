package HPC::NUMA::HBW; 

use Moose;  
use MooseX::Types::Moose qw(Bool); 
use HPC::NUMA::Types::Memory qw(Membind Preferred);  

has 'membind' => ( 
    is       => 'rw', 
    isa      => Membind, 
    coerce   => 1, 
    init_arg => undef, 
    writer   => 'set_membind',
    clearer  => '_reset_membind',
    trigger  => sub { shift->_reset_preferred }
); 

has 'preferred' => ( 
    is       => 'rw', 
    isa      => Preferred,
    coerce   => 1, 
    init_arg => undef, 
    writer   => 'set_preferred',
    clearer  => '_reset_preferred', 
    trigger  => sub { shift->_reset_membind }
); 

sub cmd {
    my $self = shift; 
    my @cmd = ('numactl'); 

    push @cmd, $self->membind   if $self->membind;  
    push @cmd, $self->preferred if $self->preferred; 

    return join(' ', @cmd); 
} 

__PACKAGE__->meta->make_immutable;

1
