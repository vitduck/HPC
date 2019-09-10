package HPC::MPI::Base; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef); 
use HPC::MPI::Types::MPI qw(NPROCS HOSTFILE); 
use namespace::autoclean; 

with qw(HPC::Share::Cmd); 

has '+bin' => ( 
    default => 'mpirun',
); 

has 'module' => ( 
    is       => 'ro', 
    isa      => Str,
    reader   => 'get_module',
    writer   => 'set_module'
); 

has 'omp' => ( 
    is        => 'rw', 
    init_arg  => undef, 
    reader    => 'get_omp',
    writer    => 'set_omp',
    predicate => '_has_omp', 
    lazy      => 1,
    default   => 1, 
); 

has 'nprocs' => (
    is        => 'rw', 
    isa       => NPROCS, 
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_nprocs',
    writer    => 'set_nprocs', 
    predicate => '_has_nprocs', 
    default   => 1,
); 

has 'hostfile' => ( 
    is        => 'ro', 
    isa       => HOSTFILE, 
    init_arg  => undef,
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_hostfile',
    predicate => '_has_hostfile', 
    default   => '$PBS_NODEFILE', 
); 

has '_env' => (
    is       => 'rw', 
    isa      => HashRef,
    traits   => ['Hash'],
    init_arg => undef,
    lazy     => 1,
    default  => sub {{}}, 
    handles  => { 
        set_env    => 'set',
        unset_env  => 'delete',
        reset_env  => 'clear', 
    } 
); 

has 'env' => ( 
    is        => 'rw', 
    init_arg  => undef,
    reader    => 'get_env',
    predicate => '_has_env', 
    lazy      => 1, 
    default   => sub {{}}
); 

after [qw(set_env unset_env reset_env)] => sub {
    my $self = shift; 

    $self->env($self->_env)
}; 

has 'eagersize' => (
    is       => 'rw', 
    isa      => Str|Int,
    init_arg => undef, 
    reader   => 'get_eagersize',
    writer   => 'set_eagersize'
); 

sub _get_opts { 
    return () 
} 

__PACKAGE__->meta->make_immutable;

1 
