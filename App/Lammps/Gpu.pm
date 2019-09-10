package HPC::App::Lammps::Gpu; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw/Num Int Str/; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

with 'HPC::App::Lammps::Package'; 

has '+name' => (
    default => 'gpu' 
); 

has '+arg' => ( 
    writer => 'set_ngpu'
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]), 
    reader    => 'get_neigh',
    writer    => 'set_neigh', 
    predicate => '_has_neigh', 
    default   => 'yes'
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    reader    => 'get_newton',
    writer    => 'set_newton', 
    predicate => '_has_newton', 
    default   => 'off',
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    reader    => 'get_binsize',
    writer    => 'set_binsize', 
    predicate => '_has_binsize',
    lazy      => 1, 
    default   => 0.0
); 

has 'split' => ( 
    is        => 'rw', 
    isa       => Num,
    reader    => 'get_split',
    writer    => 'set_split', 
    predicate => '_has_split', 
    lazy      => 1, 
    default   => 1.0,
); 

has 'gpuID' => ( 
    is        => 'rw', 
    isa       => Str, 
    reader    => 'get_gpuID',
    writer    => 'set_gpuID',
    predicate => '_has_gpuID', 
    lazy      => 1, 
    default   => 0,
); 

has 'tpa' => ( 
    is        => 'rw', 
    isa       => Int, 
    reader    => 'get_tpa', 
    writer    => 'set_tpa', 
    predicate => '_has_tpa', 
    lazy      => 1,
    default   => 1,
); 

has 'device' => ( 
    is        => 'rw', 
    isa       => Str, 
    reader    => 'get_device',
    writer    => 'set_device', 
    predicate => '_has_device', 
    lazy      => 1, 
    default   => 'fermi'
); 

has 'blocksize' => ( 
    is        => 'rw', 
    isa       => Str, 
    reader    => 'get_blocksize',
    writer    => 'set_blocksize', 
    predicate => '_has_blocksize', 
    lazy      => 1, 
    default   => 64,
); 

__PACKAGE__->meta->make_immutable;

1
