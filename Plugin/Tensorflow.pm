package HPC::Plugin::Tensorflow; 

use Moose::Role; 

use HPC::Types::Sched::Plugin 'Tensorflow'; 
use HPC::App::Tensorflow; 

use experimental 'signatures'; 

has 'tensorflow' => (
    is        => 'rw', 
    isa       => Tensorflow,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_tensorflow',
    coerce    => 1,  
    trigger  => sub ($self, $app, @) { 
        if ($self->tensorflow->_has_nccl) { 
            if ($self->tensorflow->_has_nccl_debug) { 
                $self->set_env(NCCL_DEBUG => $self->tensorflow->nccl->debug) 
            }
            
            # enable/disable gpudirect p2p
            if ($self->tensorflow->_has_nccl_p2p) { 
                $self->tensorflow->nccl->p2p == 0 
                ? $self->set_env(NCCL_P2P_DISABLE => 1)
                : $self->set_env(NCCL_P2P_DISABLE => 0)
            } 
                
            # enable/disable gpudirect rdma
            if ($self->tensorflow->_has_nccl_rdma) { 
                $self->tensorflow->nccl->rdma == 0
                ? $self->set_env(NCCL_NET_GDR_LEVEL => 0)
                : $self->set_env(NCLL_NET_GDR_LEVEL => $self->tensorflow->nccl->rdma)
            } 

            # enable mpi threads
            if ($self->tensorflow->_has_nccl_threads) { 
                $self->tensorflow->nccl->threads == 0
                ? $self->set_env(HOROVOD_MPI_THREADS_DISABLE => 1)
                : $self->set_env(HOROVOD_MPI_THREADS_DISABLE => 0)
            } 
        } 
    }
); 

1
