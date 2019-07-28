package HPC::MPI::Lib; 

use Moose::Role;  
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Str HashRef/; 

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
    is      => 'ro', 
    isa     => Str, 
    default => ''
); 

sub cmd {
    my ($self, $select, $ncpus, $omp) = @_; 

    # for example: I_IMPI_DEBUG=5
    my @envs = map { join('=', $_, $self->get_env($_)) } $self->list_env; 

    # IMPI:-env/OPENMPI:-x/MVAPICH2:null 
    @envs = map { ($self->env_opt, $_) } @envs if $self->env_opt; 

    return 
        $self->has_env 
        ? ($self->mpirun, join(' ', @envs)) 
        : ($self->mpirun)
}

1 
