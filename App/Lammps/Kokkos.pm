package HPC::App::Lammps::Kokkos;  

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num/; 
use namespace::autoclean; 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    default   => 'half',
    predicate => '_has_neigh', 
    writer    => 'set_neigh',
); 

has 'neigh_qeq' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    predicate => '_has_neigh_qeq', 
    writer    => 'set_neigh_qeq',
); 

has 'neigh_thread' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    predicate => '_has_neigh_thread', 
    writer    => 'set_neigh_thread',
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    default   => 'on',
    predicate => '_has_newton', 
    writer    => 'set_newton',
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => '_has_binsize', 
    writer    => 'set_binsize',
); 

has 'comm' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    predicate => '_has_comm', 
    writer    => 'set_comm',
); 

has 'comm_exchange' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    predicate => '_has_comm_exchange', 
    writer    => 'set_comm_exchange',
); 

has 'comm_forward' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    predicate => '_has_comm_forward', 
    writer    => 'set_comm_forward',
); 

has 'comm_reverse' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    predicate => '_has_comm_reverse', 
    writer    => 'set_comm_reverse',
); 

has 'gpu_direct' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    predicate => '_has_gpu_direct', 
    writer    => 'set_gpu_direct',
); 

sub pkg_opt { 
    my $self = shift; 
    my @pkgs = ('kokkos'); 
    
    for my $attr ( $self->meta->get_attribute_list ) { 
        my $predicate = "_has_$attr"; 
    
        push @pkgs, $attr, $self->$attr if $self->$predicate; 
    }

    @pkgs = map { s/_/\//; $_ } @pkgs;  

    return [@pkgs]
} 

__PACKAGE__->meta->make_immutable;

1
