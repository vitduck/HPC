package HPC::MPI::Lib; 

use Moose::Role;  
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Str Int HashRef/; 

requires 
    '_build_env_opt'; 

has 'module' => ( 
    is       => 'ro', 
    isa      => enum([qw/impi openmpi mvapich2/]), 
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

has 'env' => (
    is        => 'rw', 
    isa       => HashRef,
    traits    => ['Hash'],
    init_arg  => undef,
    handles   => { 
        has_env   => 'count', 
        get_env   => 'get', 
        set_env   => 'set',
        unset_env => 'delete',
        reset_env => 'clear', 
        list_env  => 'keys', 
    } 
); 

has 'env_opt' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_env_opt',  
    clearer  => '_reset_env_opt'
); 

sub cmd { 
    my ($self, $omp) = @_; 

    my @opts = ($self->mpirun); 

    push @opts, $self->env_opt if $self->env_opt; 

    return @opts; 
} 

1 
