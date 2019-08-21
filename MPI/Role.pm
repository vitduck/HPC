package HPC::MPI::Role; 

use Moose::Role;  
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef); 
use HPC::MPI::Options    qw(NPROCS HOSTFILE); 

requires 'opt'; 

has 'module' => ( 
    is       => 'ro', 
    isa      => enum([qw/cray-impi impi openmpi mvapich2/]), 
    required => 1
); 

has 'version' => ( 
    is       => 'ro', 
    isa      => Str, 
    required => 1
); 

has 'mpirun' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef, 
    default  => 'mpirun', 
); 

has 'omp' => ( 
    is       => 'rw', 
    init_arg  => undef, 
    lazy      => 1,
    predicate => 'has_omp', 
    writer    => 'set_omp',
    default   => 1, 
); 

has 'nprocs' => (
    is       => 'rw', 
    isa      => NPROCS, 
    writer   => 'set_nprocs', 
    coerce   => 1, 
); 

has 'hostfile' => ( 
    is       => 'ro', 
    isa      => HOSTFILE, 
    coerce   => 1, 
    default  => '$PBS_NODEFILE', 
); 

has '_env' => (
    is       => 'rw', 
    isa      => HashRef,
    traits   => ['Hash'],
    init_arg => undef,
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
    default  => sub {{}}
); 

has 'eagersize' => ( 
    is       => 'rw', 
    isa      => Str|Int,
    init_arg => undef, 
    writer   => 'set_eagersize'
); 


1 
