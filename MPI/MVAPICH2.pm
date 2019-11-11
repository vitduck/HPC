package HPC::MPI::MVAPICH2; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use HPC::MPI::Types::MVAPICH2 qw(ENV_MVAPICH2); 
use namespace::autoclean; 

use feature 'signatures';
no warnings 'experimental::signatures';

extends qw(HPC::MPI::Base); 

has '+bin' => ( 
    default => 'mpirun_rsh' 
); 

has '+hostfile' => ( 
    lazy => 0 
); 

has '+omp' => ( 
    trigger => sub ($self, $omp, @) { 
        $self->set_env( 
            PSM2_KASSIST_MODE       => 'none', 
            OMP_NUM_THREADS         => $omp,  
            MV2_THREADS_PER_PROCESS => $omp, 
            MV2_ENABLE_AFFINITY     => 1,
            MV2_CPU_BINDING_POLICY  => 'hybrid', 
        ); 
    }
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        $self->set_env(
            MV2_SHOW_ENV_INFO        => 2, 
            MV2_SHOW_CPU_BINDING     => 1, 
            MV2_DEBUG_SHOW_BACKTRACE => 1
        )
    } 
); 

has '+eager' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env( MV2_SMP_EAGERSIZE => $size )
    }
); 

has '+env_opt' => ( 
    isa    => ENV_MVAPICH2, 
    coerce => 1 
); 

override '_get_opts' => sub { 
    return qw(nprocs hostfile env_opt)
}; 

__PACKAGE__->meta->make_immutable;

1
