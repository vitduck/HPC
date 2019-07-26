package HPC::App::LAMMPS::KOKKOS;  

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num/; 

use HPC::App::LAMMPS::Types qw/Kokkos/; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => ( 
    default => 'kk'
); 

has 'kokkos' => ( 
    is      => 'rw', 
    isa     => Kokkos, 
    coerce  => 1, 
    default => 'on'
); 

has 'neigh' => ( 
    is      => 'rw', 
    isa     => enum([qw/full half/]), 
    trigger => sub { shift->_reset_package }
); 

has 'neigh_qeq' => ( 
    is      => 'rw', 
    isa     => enum([qw/full half/]), 
    trigger => sub { shift->_reset_package }
); 

has 'neigh_thread' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    trigger => sub { shift->_reset_package }
); 

has 'newton' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    trigger => sub { shift->_reset_package }
); 

has 'binsize' => ( 
    is      => 'rw', 
    isa     => Num,
    trigger => sub { shift->_reset_package }
); 

has 'comm' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    trigger => sub { shift->_reset_package }
); 

has 'comm_exchange' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    trigger => sub { shift->_reset_package }
); 

has 'comm_forward' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    trigger => sub { shift->_reset_package }
); 

has 'comm_reverse' => ( 
    is      => 'rw', 
    isa     => enum([qw/no host device/]), 
    trigger => sub { shift->_reset_package }
); 

has 'gpu_direct' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    trigger => sub { shift->_reset_package }
); 

sub _build_package { 
    my $self = shift; 
    my @opts = ();  

    push @opts, 'kokkos'; 

    for (qw( 
        neigh neigh_qeq neigh_thread 
        newton binsize
        comm comm_exchange comm_forward comm_reverse
        gpu_direct)) { 
        
        push @opts, s/_/\//r, $self->$_ if $self->$_; 
    }

    return join(' ', @opts); 
} 

around 'cmd' => sub { 
    my $orig = shift; 
    my $self = shift; 

    return join(' ', $self->kokkos, $self->$orig)
};  

__PACKAGE__->meta->make_immutable;

1
