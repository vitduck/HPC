package HPC::App::Lammps::Kokkos;  

use Moose; 
use MooseX::Attribute::Chained; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num/; 
use namespace::autoclean; 

with 'HPC::App::Lammps::Package'; 

has '+name' => (
    default => 'kokkos' 
); 

has '+arg' => ( 
    lazy => 1
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    traits    => ['Chained'],
    predicate => '_has_neigh', 
    default   => 'half',
); 

has 'neigh_qeq' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    traits    => ['Chained'],
    predicate => '_has_neigh_qeq', 
    lazy      => 1, 
    default   => 'half'
); 

has 'neigh_thread' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    traits    => ['Chained'],
    predicate => '_has_neigh_thread', 
    default   => 'on',
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    traits    => ['Chained'],
    predicate => '_has_newton', 
    default   => 'on',
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    traits    => ['Chained'],
    predicate => '_has_binsize', 
    lazy      => 1, 
    default   => 0.0
); 

has 'comm' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    traits    => ['Chained'],
    predicate => '_has_comm', 
    
); 

has 'comm_exchange' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    traits    => ['Chained'],
    predicate => '_has_comm_exchange', 
); 

has 'comm_forward' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    traits    => ['Chained'],
    predicate => '_has_comm_forward', 
); 

has 'comm_reverse' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    traits    => ['Chained'],
    predicate => '_has_comm_reverse', 
); 

has 'gpu_direct' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    traits    => ['Chained'],
    predicate => '_has_gpu_direct', 
); 

around 'pkg_opt' => sub { 
    my ($opt, $self) = @_; 

    return [ map { s/_/\//; $_ } $self->$opt->@* ]
};  

__PACKAGE__->meta->make_immutable;

1
