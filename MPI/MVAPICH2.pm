package HPC::MPI::MVAPICH2; 

use Moose; 
use MooseX::XSAccessor; 
use HPC::MPI::Types::MVAPICH2 qw(ENV_MVAPICH2); 
use namespace::autoclean; 

extends qw(HPC::MPI::Base); 

has '+bin' => ( 
    default => 'mpirun_rsh'
); 

has '+hostfile' => ( 
    lazy => 0
); 

has '+omp' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env( 
            OMP_NUM_THREADS         => $self->get_omp,  
            MV2_THREADS_PER_PROCESS => $self->get_omp, 
            MV2_ENABLE_AFFINITY     => 1 
        ); 
    }
); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env( 
            MV2_SMP_EAGERSIZE => $self->get_eagersize 
        ); 
    }
); 

has '+env' => ( 
    isa    => ENV_MVAPICH2, 
    coerce => 1
); 

override '_get_opts' => sub { 
    return qw(nprocs hostfile env)
}; 

__PACKAGE__->meta->make_immutable;

1
