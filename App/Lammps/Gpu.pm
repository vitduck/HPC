package HPC::App::Lammps::Gpu; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw/Num Int Str/; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

with 'HPC::App::Lammps::Package'; 

has '+name' => (
    default => 'gpu' 
); 

has '+arg' => ( 
    writer => 'ngpu'
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]), 
    traits    => ['Chained'],
    predicate => '_has_neigh', 
    default   => 'yes'
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    traits    => ['Chained'],
    predicate => '_has_newton', 
    default   => 'off',
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    traits    => ['Chained'],
    predicate => '_has_binsize',
    lazy      => 1, 
    default   => 0.0
); 

has 'split' => ( 
    is        => 'rw', 
    isa       => Num,
    traits    => ['Chained'],
    predicate => '_has_split', 
    lazy      => 1, 
    default   => 1.0,
); 

has 'gpuID' => ( 
    is        => 'rw', 
    isa       => Str, 
    traits    => ['Chained'],
    predicate => '_has_gpuID', 
    lazy      => 1, 
    default   => 0,
); 

has 'tpa' => ( 
    is        => 'rw', 
    isa       => Int, 
    traits    => ['Chained'],
    predicate => '_has_tpa', 
    lazy      => 1,
    default   => 1,
); 

has 'device' => ( 
    is        => 'rw', 
    isa       => Str, 
    traits    => ['Chained'],
    predicate => '_has_device', 
    lazy      => 1, 
    default   => 'fermi'
); 

has 'blocksize' => ( 
    is        => 'rw', 
    isa       => Str, 
    traits    => ['Chained'],
    predicate => '_has_blocksize', 
    lazy      => 1, 
    default   => 64,
); 

__PACKAGE__->meta->make_immutable;

1
