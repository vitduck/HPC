package HPC::App::Lammps::Intel; 

use Moose; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

with 'HPC::App::Lammps::Package'; 

has '+name' => (
    default => 'intel' 
); 

has '+arg' => ( 
    writer => 'nphi'
); 

has 'mode' => ( 
    is        => 'rw', 
    isa       => enum([qw/single mixed double/]),
    traits    => ['Chained'],
    lazy      => 1, 
    predicate => '_has_mode',
    default   => 'mixed',
); 

has 'omp' => ( 
    is        => 'rw', 
    isa       => Int,
    traits    => ['Chained'],
    lazy      => 1, 
    predicate => '_has_omp',
    default   => 1
); 

has 'lrt' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    lazy      => 1, 
    traits    => ['Chained'],
    predicate => '_has_lrt',
    default   => 'no'
); 

has 'balance' => ( 
    is        => 'rw', 
    isa       => Num,
    traits    => ['Chained'],
    predicate => '_has_balance',
); 

has 'ghost' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    traits    => ['Chained'],
    predicate => '_has_ghost',
); 

has 'tpc' => ( 
    is        => 'rw', 
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_tpc',
); 

has 'tptask' => ( 
    is        => 'rw', 
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_tptask',
); 

__PACKAGE__->meta->make_immutable;

1
