package HPC::Mpi::Base; 

use Moose::Role;  
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef); 
use HPC::Types::Mpi::Base qw(Nprocs Hostfile); 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
    HPC::Debug::Dump 
    HPC::Mpi::Affinity
    HPC::Plugin::Cmd); 

has 'bin' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef,
    traits   => ['Chained'],
    default  => 'mpirun'
); 

has 'module' => (
    is     => 'ro', 
    isa    => Str,
    traits => ['Chained'] 
);

has 'omp' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    init_arg  => undef, 
    predicate => '_has_omp', 
    lazy      => 1,
    default   => 1 
);

has 'nprocs' => (
    is        => 'rw', 
    isa       => Nprocs, 
    traits   => ['Chained'],
    predicate => '_has_nprocs', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 1,
);

has 'hostfile' => ( 
    is        => 'rw', 
    isa       => Hostfile, 
    traits    => ['Chained'],
    init_arg  => undef,
    predicate => '_has_hostfile', 
    coerce    => 1, 
    lazy      => 1, 
    default   => '' 
);

has 'debug' => ( 
    is       => 'rw', 
    isa      => Int,
    traits   => ['Chained'],
    lazy     => 1, 
    default  => 4, 
); 

has 'eagersize' => (
    is       => 'rw', 
    isa      => Str|Int,
    traits   => ['Chained'],
); 

has 'env' => (
    is       => 'rw', 
    isa      => HashRef,
    traits   => [qw(Hash Chained)],
    init_arg => undef,
    default  => sub {{}}, 
    handles  => { 
           has_env => 'count', 
          list_env => 'keys', 
           get_env => 'get', 
           set_env => 'set', 
         unset_env => 'delete' }, 
    trigger  => sub ($self, $env, @) {  
        $self->has_env 
        ? $self->env_opt($env) 
        : $self->_unset_env_opt } 
); 

has env_opt => ( 
    is        => 'rw', 
    init_arg  => undef,
    predicate => '_has_env_opt',
    clearer   => '_unset_env_opt',
    lazy      => 1, 
    default   => sub {{}},  
); 

1 
