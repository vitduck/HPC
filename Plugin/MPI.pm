package HPC::Plugin::MPI; 

use Moose;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef); 
use HPC::Plugin::Types::MPI qw(NPROCS HOSTFILE); 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
    HPC::Debug::Dump 
    HPC::Plugin::Cmd ); 

has '+bin' => (
    default => 'mpirun' 
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
    isa       => NPROCS, 
    traits   => ['Chained'],
    predicate => '_has_nprocs', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 1 
);

has 'hostfile' => ( 
    is        => 'ro', 
    isa       => HOSTFILE, 
    traits    => ['Chained'],
    init_arg  => undef,
    predicate => '_has_hostfile', 
    coerce    => 1, 
    lazy      => 1, 
    default   => '$PBS_NODEFILE' 
);

has 'debug' => ( 
    is       => 'rw', 
    isa      => Int,
    init_arg => undef,
    traits   => ['Chained'],
    lazy     => 1, 
    default  => 0, 
); 

has 'eager' => (
    is       => 'rw', 
    isa      => Str|Int,
    init_arg => undef, 
    traits   => ['Chained'],
); 

has 'env' => (
    is       => 'rw', 
    isa      => HashRef,
    traits   => [qw(Hash Chained)],
    init_arg => undef,
    clearer  => 'reset_env', 
    lazy     => 1,
    default  => sub {{}}, 
    handles  => { 
          set_env => 'set', 
        unset_env => 'delete' 
    }, 
    trigger  => sub ($self, @args) { 
        $self->env_opt(shift @args)
    } 
); 

has 'env_opt' => ( 
    is        => 'rw', 
    init_arg  => undef, 
    predicate => '_has_env_opt',
    clearer   => '_reset_env_opt',
    lazy      => 1,  
    default   => sub {{}} 
);  

# required to be implemented by HPC::Share::Cmd 
sub _get_opts { 
    return () 
} 

__PACKAGE__->meta->make_immutable;

1 
