package HPC::Plugin::Nccl; 

use Moose::Role; 
use MooseX::Types::Moose 'HashRef'; 

use namespace::autoclean; 
use experimental 'signatures'; 

has nccl => ( 
    is        => 'rw', 
    isa       => HashRef,
    init_arg  => undef,
    traits    => [qw(Chained Hash)],
    predicate => '_has_nccl',
    lazy      => 1, 
    default   => sub {{ 
        thread => 1, 
        p2p    => 0, 
        rdma   => 0}
    }, 
    handles   => { 
        _get_nccl_env => 'get', 
        _has_nccl_env => 'defined'
    },
    trigger   => sub ($self, $nccl, @) { 
        # debug information
        if ($self->_has_nccl_env('debug')) {  
            $self->set_env(NCCL_DEBUG => $self->_get_nccl_env('debug')) 
        }
        
        # gpudirect p2p
        if ( $self->_has_nccl_env('p2p') ) {  
            $self->_get_nccl_env('p2p') == 0
            ? $self->set_env(NCCL_P2P_DISABLE => 1)
            : $self->set_env(NCCL_P2P_DISABLE => 0)
        }

        # gpudirect rdma
        if ( $self->_has_nccl_env('rdma') ) {  
            $self->_get_nccl_env('rdma') == 0 
            ? $self->set_env(NCCL_NET_GDR_LEVEL => 0)
            : $self->set_env( 
                NCCL_NET_GDR_LEVEL          => $self->_get_nccl_env('rdma'), 
                HOROVOD_MPI_THREADS_DISABLE => 1) 
        }

        # disable threads for GPUDIRECT-RDMA
        if ( $self->_has_nccl_env('threads') ) {  
            $self->_get_nccl_env('threads') == 0
            ? $self->set_env(HOROVOD_MPI_THREADS_DISABLE => 1) 
            : $self->set_env(HOROVOD_MPI_THREADS_DISABLE => 0) 
        }
    } 
); 

1
