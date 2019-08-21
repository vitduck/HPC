package HPC::MPI::MVAPICH2::Module; 

use Moose; 
use HPC::MPI::MVAPICH2::Options qw(ENV_MVAPICH2); 
use namespace::autoclean; 

with 'HPC::MPI::Role'; 

has '+mpirun' => ( 
    default => 'mpirun_rsh'
); 

has '+omp' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env( 
            OMP_NUM_THREADS         => $self->omp,  
            MV2_THREADS_PER_PROCESS => $self->omp, 
            MV2_ENABLE_AFFINITY     => 1
        )
    }
); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env(MV2_SMP_EAGERSIZE => $self->eagersize); 
    }
); 

has '+env' => ( 
    isa    => ENV_MVAPICH2, 
    coerce => 1
); 

sub opt { 
    my $self = shift; 
    my @opts = ($self->nprocs, $self->hostfile);

    push @opts, $self->env($self->_env) if $self->has_env; 

    return @opts; 
};  

__PACKAGE__->meta->make_immutable;

1
