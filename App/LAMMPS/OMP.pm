package HPC::App::LAMMPS::OMP; 

use Moose; 
use MooseX::Types::Moose qw/Int Str/; 
use Moose::Util::TypeConstraints; 

with 'HPC::App::LAMMPS::Package'; 

has '+name' => ( 
    default => 'omp'
); 

has '+arg' => ( 
    default => 'nthreads'
); 

has '+opts' => ( 
    default => sub {['neigh']}  
); 

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
    trigger => sub { shift->_reset_package }
); 

__PACKAGE__->meta->make_immutable;

1
