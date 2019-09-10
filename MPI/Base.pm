package HPC::MPI::Base; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
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
    traits   => ['Chained'],
); 

has 'omp' => ( 
    is        => 'rw', 
    traits   => ['Chained'],
    init_arg  => undef, 
    predicate => '_has_omp', 
    lazy      => 1,
    default   => 1, 
); 

has 'nprocs' => (
    is        => 'rw', 
    isa       => NPROCS, 
    traits   => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_nprocs', 
    default   => 1,
); 

has 'hostfile' => ( 
    is        => 'ro', 
    isa       => HOSTFILE, 
    traits   => ['Chained'],
    init_arg  => undef,
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_hostfile', 
    default   => '$PBS_NODEFILE', 
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
        set_env   => 'set', 
        unset_env => 'delete', 
    },  
    trigger  => sub { 
        my $self = shift; 

        $self->env_opt($self->env)
    }
); 

has 'env_opt' => ( 
    is        => 'rw', 
    init_arg  => undef, 
    lazy      => 1,  
    clearer   => '_unset_env_opt',
    predicate => '_has_env_opt',
    default   => sub {{}}
); 

has 'eagersize' => (
    is       => 'rw', 
    isa      => Str|Int,
    traits   => ['Chained'],
    init_arg => undef, 
); 

after [qw(set_env unset_env)] => sub {
    my $self = shift; 

    $self->env_opt($self->env)
}; 

after 'reset_env' => sub {
    my $self = shift; 

    $self->_unset_env_opt
}; 

sub _get_opts { 
    return () 
} 

__PACKAGE__->meta->make_immutable;

1 
