package HPC::App::Lammps::Omp; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw/Int Str/; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

with 'HPC::App::Lammps::Package'; 

has '+name' => (
    default => 'omp', 
); 

has '+arg' => ( 
    writer => 'set_nthreads'
); 

has 'neigh' => (
    is        => 'rw', 
    isa       => enum([qw/yes no/]), 
    reader    => 'get_neigh',
    writer    => 'set_neigh',
    predicate => '_has_neigh', 
    default   => 'yes'
); 

__PACKAGE__->meta->make_immutable;

1
