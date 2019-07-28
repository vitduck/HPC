package HPC::MPI::Lib; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Undef Str Int HashRef/; 

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
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef, 
    default  => sub { shift->module eq  'mvapich2' ? 'mpirun_rsh' : 'mpirun' }, 
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

sub env_opt {
    my $self = shift; 

    # env=value pari 
    my @opts = map join('=', $_, $self->get_env($_)), $self->list_env; 

    # environement options 
    return  
        $self->module eq 'impi'    ? map { ('-env', $_) } @opts : 
        $self->module eq 'openmpi' ? map { ('-x'  , $_) } @opts : 
        @opts; 
}

__PACKAGE__->meta->make_immutable;

1 
