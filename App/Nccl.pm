package HPC::App::Nccl; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::Types::Moose 'HashRef'; 

use namespace::autoclean;
use experimental 'signatures'; 

has 'debug' => (
    is        => 'rw', 
    isa       => enum([qw(VERSION WARN INFO)]), 
    predicate => '_has_debug',
    traits    => ['Chained'], 
    default   => 'VERSION', 
    trigger   => sub ($self, $env, @) { 
        $self->set_env(NCCL_DEBUG => $env)
    }
);

has 'shm' => (
    is        => 'rw', 
    isa       => enum([qw(0 1)]),
    predicate => '_has_shm',
    traits    => ['Chained'], 
    default   => '1', 
    trigger   => sub ($self, $env, @) { 
        $self->set_env(NCCL_SHM_DISABLE => $env ? 0 : 1) 
    } 
);

has 'p2p' => (
    is        => 'rw', 
    isa       => enum([qw(0 1)]),
    predicate => '_has_p2p',
    traits    => ['Chained'], 
    default   => '1', 
    trigger   => sub ($self, $env, @) {
        $self->set_env(NCCL_P2P_DISABLE => $env ? 0 : 1)   
    } 
); 

has 'ib' => (
    is        => 'rw', 
    isa       => enum([qw(0 1)]),
    predicate => '_has_ib',
    traits    => ['Chained'], 
    default   => '1', 
    trigger   => sub ($self, $env, @) {
        $self->set_env(NCCL_IB_DISABLE => $env ? 0 : 1)   
    } 
); 

has 'rdma' => (
    is        => 'rw', 
    isa       => enum([qw(0 1 2 3 4 5)]),
    predicate => '_has_rdma',
    traits    => ['Chained'], 
    default   => 2,
    trigger   => sub ($self, $env, @) { 
        # rdma doesn't work well with mpi thread
        $self->set_env(
            NCLL_NET_GDR_LEVEL          => $env, 
            HOROVOD_MPI_THREADS_DISABLE => $env ? 1 : 0
        ) 
    } 
); 

has 'threads' => (
    is        => 'rw', 
    isa       => enum([qw(0 1)]),
    predicate => '_has_threads',
    traits    => ['Chained'], 
    default   => 1,
    trigger   => sub ($self, $env , @) { 
        $self->set_env(HOROVOD_MPI_THREADS_DISABLE => $env ? 0 : 1) 
    } 
);  

has 'env' => (
    is        => 'rw', 
    isa       => HashRef, 
    init_arg  => undef, 
    traits    => ['Hash'],
    predicate => '_has_env', 
    lazy      => 1, 
    default   => sub {{}}, 
    handles   => { 
         set_env => 'set', 
         get_env => 'get',
        list_env => 'keys'
    }
);

__PACKAGE__->meta->make_immutable;

1
