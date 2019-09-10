package HPC::App::Lammps::Intel; 

use Moose; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

with 'HPC::App::Lammps::Package'; 

has '+name' => (
    default => 'intel' 
); 

has '+arg' => ( 
    writer => 'set_nphi'
); 

has 'mode' => ( 
    is        => 'rw', 
    isa       => enum([qw/single mixed double/]),
    lazy      => 1, 
    reader    => 'get_mode',
    writer    => 'set_mode', 
    predicate => '_has_mode',
    default   => 'mixed',
); 

has 'omp' => ( 
    is        => 'rw', 
    isa       => Int,
    lazy      => 1, 
    reader    => 'get_omp',
    writer    => 'set_omp',
    predicate => '_has_omp',
    default   => 1
); 

has 'lrt' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    lazy      => 1, 
    reader    => 'get_lrt',
    writer    => 'set_lrt',
    predicate => '_has_lrt',
    default   => 'no'
); 

has 'balance' => ( 
    is        => 'rw', 
    isa       => Num,
    reader    => 'get_balance',
    writer    => 'set_balance',
    predicate => '_has_balance',
); 

has 'ghost' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    reader    => 'get_ghost',
    writer    => 'set_ghost',
    predicate => '_has_ghost',
); 

has 'tpc' => ( 
    is        => 'rw', 
    isa       => Int,
    reader    => 'get_tpc',
    writer    => 'set_tpc',
    predicate => '_has_tpc',
); 

has 'tptask' => ( 
    is        => 'rw', 
    isa       => Int,
    reader    => 'get_tptask',
    writer    => 'set_tptask',
    predicate => '_has_tptask',
); 

__PACKAGE__->meta->make_immutable;

1
