package HPC::App::LAMMPS::KOKKOS;  

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num/; 

use HPC::App::LAMMPS::Types qw/Kokkos/; 

with 'HPC::App::LAMMPS::Package'; 

has '+_opt' => ( 
    default => sub {[qw/
        neigh neigh_qeq neigh_thread 
        newton binsize 
        comm comm_exchange comm_forward comm_reverse 
        gpu_direct/
    ]}
); 

has '+suffix' => ( 
    default => 'kk'
); 

has 'kokkos' => ( 
    is      => 'rw', 
    isa     => Kokkos, 
    coerce  => 1, 
    default => 1, 
    writer  => 'set_kokkos',   
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    default   => 'half',
    predicate => 'has_neigh'
); 

has 'neigh_qeq' => ( 
    is      => 'rw', 
    isa     => enum([qw/full half/]), 
    predicate => 'has_neigh_qeq'
); 

has 'neigh_thread' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    predicate => 'has_neigh_thread'
); 

has 'newton' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    default => 'on',
    predicate => 'has_newton'
); 

has 'binsize' => ( 
    is      => 'rw', 
    isa     => Num,
    predicate => 'has_binsize'
); 

has 'comm' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    predicate => 'has_comm'
); 

has 'comm_exchange' => ( 
    is        => 'rw', 
    isa       => enum([qw/no host device/]), 
    predicate => 'has_comm_exchange'
); 

has 'comm_forward' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    predicate => 'has_comm_forward'
); 

has 'comm_reverse' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    predicate => 'has_comm_reverse'
); 

has 'gpu_direct' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    predicate => 'has_gpu_direct'
); 

around 'opt' => sub {
    my ($opt, $self) = @_; 
    
    # for neight/* comm/* and gpu/direct
    my @opts = map { s/_/\//; $_ } $self->$opt->@*; 

    return ['kokkos', @opts]
}; 

around 'cmd' => sub { 
    my ($cmd, $self) = @_; 

    return ($self->kokkos, $self->$cmd)
}; 

__PACKAGE__->meta->make_immutable;

1
