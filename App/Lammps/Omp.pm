package HPC::App::Lammps::Omp; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
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
    traits    => ['Chained'],
    predicate => '_has_neigh', 
    default   => 'yes'
); 

__PACKAGE__->meta->make_immutable;

1
