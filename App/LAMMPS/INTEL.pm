package HPC::App::LAMMPS::INTEL; 

use Moose; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 

use HPC::App::LAMMPS::Types qw/Suffix/; 

with 'HPC::App::LAMMPS::Package'; 

has '+name' => ( 
    default => 'intel'
); 

has '+arg' => ( 
    default => 'Nphi'
); 

has '+opts' => ( 
    default => sub {[qw/omp mode lrt balance ghost tpc tptask/]}
); 

has '+suffix' => ( 
    default => 'intel',
); 

has 'suffix' => ( 
    is      => 'rw',
    isa     => Suffix,
    coerce  => 1, 
    default => 'intel',
); 

has 'Nphi' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

has 'mode' => ( 
    is      => 'rw', 
    isa     => enum([qw/single mixed double/]),
    default => 'mixed',
    trigger => sub { shift->_reset_package }
); 

has 'omp' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'lrt' => ( 
    is      => 'rw', 
    isa     => enum([qw/yes no/]),
    trigger => sub { shift->_reset_package }
); 

has 'balance' => ( 
    is      => 'rw', 
    isa     => Num,
    trigger => sub { shift->_reset_package }
); 

has 'ghost' => ( 
    is      => 'rw', 
    isa     => enum([qw/yes no/]),
    trigger => sub { shift->_reset_package }
); 

has 'tpc' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'tptask' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'no_affinity' => ( 
    is      => 'rw', 
    isa     => Bool,
    trigger => sub { shift->_reset_package }
); 

__PACKAGE__->meta->make_immutable;

1
