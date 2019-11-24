package HPC::Mpi::Affinity; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 
use feature 'signatures';
no warnings 'experimental::signatures';

has 'pin' => ( 
    is       => 'rw', 
    init_arg => undef,
    traits   => ['Chained'],
); 

has 'map' => ( 
    is        => 'rw', 
    init_arg  => undef,
    traits    => ['Chained'],
    predicate => '_has_map', 
    clearer   => '_reset_map' 
); 

has 'bind' => ( 
    is       => 'rw', 
    init_arg => undef,
    traits   => ['Chained'],
    predicate => '_has_bind', 
    clearer   => '_reset_bind' 
); 

1
