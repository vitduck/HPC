package HPC::MPI::Base; 

use Moose::Role;  
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef); 

use HPC::MPI::Types::MPI qw(NPROCS HOSTFILE); 

requires 'mpirun'; 

has 'module' => ( 
    is       => 'ro', 
    isa      => 'Str', 
    writer   => 'set_module',
); 

has 'omp' => ( 
    is        => 'rw', 
    init_arg  => undef, 
    predicate => 'has_omp', 
    writer    => 'set_omp',
    lazy      => 1,
    default   => 1, 
); 

has 'nprocs' => (
    is       => 'rw', 
    isa      => NPROCS, 
    coerce   => 1, 
    lazy     => 1, 
    writer   => 'set_nprocs', 
    default  => 1,
); 

has 'hostfile' => ( 
    is       => 'ro', 
    isa      => HOSTFILE, 
    init_arg => undef,
    coerce   => 1, 
    lazy     => 1, 
    default  => '$PBS_NODEFILE', 
); 

has '_env' => (
    is       => 'rw', 
    isa      => HashRef,
    traits   => ['Hash'],
    init_arg => undef,
    lazy     => 1,
    default  => sub {{}}, 
    handles  => { 
        has_env   => 'count', 
        get_env   => 'get', 
        set_env   => 'set',
        unset_env => 'delete',
        reset_env => 'clear', 
        list_env  => 'keys', 
    } 
); 

has 'env' => ( 
    is       => 'rw', 
    init_arg => undef,
    lazy     => 1,
    default  => sub {{}}, 
); 

has 'eagersize' => ( 
    is       => 'rw', 
    isa      => Str|Int,
    init_arg => undef, 
    writer   => 'set_eagersize'
); 

1 
