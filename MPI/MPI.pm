package HPC::MPI::MPI; 

use Moose::Role;  
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef); 
use HPC::MPI::Options    qw(NPROCS HOSTFILE); 

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
    init_arg => undef, 
    default  => 1, 
); 

has 'nprocs' => (
    is       => 'rw', 
    isa      => NPROCS, 
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

sub opt { 
    my $self = shift; 
    my @opts = (); 

    push @opts, $self->env, $self->omp; 
    
    return grep $_, @opts
} 

1 
