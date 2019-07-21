package HPC::App::LAMMPS::OMP; 

use Moose; 
use MooseX::Types::Moose qw/Int Str/; 
use Moose::Util::TypeConstraints; 

with 'HPC::App::LAMMPS::Package'; 

my @attrs  =  qw(nthreads neigh); 

has '+suffix' => (
    default => 'omp',
);

has 'nthreads' => ( 
    is      => 'rw', 
    isa     => Int,
    default => 0, 
    trigger => sub { shift->_reset_package }
); 

has 'neigh' => ( 
    is      => 'rw', 
    isa     => enum([qw/yes no/]), 
    default => 'yes', 
    trigger => sub { shift->_reset_package }
); 

sub _build_package { 
    my $self = shift; 
    my @opts = (); 

    push @opts, 'omp'  , $self->nthreads;
    push @opts, 'neigh', $self->neigh if $self->neigh; 

    return join(' ', @opts)
} 

__PACKAGE__->meta->make_immutable;

1
