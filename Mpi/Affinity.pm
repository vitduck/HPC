package HPC::Mpi::Affinity; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 
use feature 'signatures';
no warnings 'experimental::signatures';

has 'pin' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_pin', 
    clearer   => '_unset_pin', 
); 

has 'map' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_map', 
    clearer   => '_unset_map', 
); 

has 'bind' => ( 
    is       => 'rw', 
    traits   => ['Chained'],
    predicate => '_has_bind', 
    clearer   => '_unset_bind',
); 

1
