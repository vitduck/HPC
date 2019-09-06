package HPC::App::Numa; 

use Moose;  
use HPC::App::Types::Numa qw(Membind Preferred);  
use Text::Tabs; 

with qw(HPC::App::Base); 

has 'membind' => ( 
    is        => 'rw', 
    isa       => Membind,
    coerce    => 1, 
    lazy      => 1, 
    predicate => 'has_membind', 
    writer    => 'set_membind', 
    default   => 'mcdram', 
); 

has 'preferred' => ( 
    is        => 'rw', 
    isa       => Preferred,
    coerce    => 1, 
    lazy      => 1, 
    predicate => 'has_preferred', 
    writer    => 'set_preferred',
    default   => 'mcdram',
); 

sub cmd {
    my $self  = shift; 
    my @opts  = (); 
    $tabstop  = 4; 

    push @opts, $self->membind   if $self->has_membind; 
    push @opts, $self->preferred if $self->has_preferred; 

    return ['numactl', expand(map "\t".$_, @opts)]
} 

__PACKAGE__->meta->make_immutable;

1
