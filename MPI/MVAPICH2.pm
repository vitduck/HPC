package HPC::MPI::MVAPICH2; 

use Text::Tabs; 
use Moose; 
use HPC::MPI::Types::MVAPICH2 qw(ENV_MVAPICH2); 
use namespace::autoclean; 

with qw(HPC::MPI::Base); 

has '+omp' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env( OMP_NUM_THREADS         => $self->omp,  
                        MV2_THREADS_PER_PROCESS => $self->omp, 
                        MV2_ENABLE_AFFINITY     => 1 ); 
    }
); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env( MV2_SMP_EAGERSIZE => $self->eagersize ); 
    }
); 

has '+env' => ( 
    isa    => ENV_MVAPICH2, 
    coerce => 1
); 

sub mpirun { 
    my $self = shift; 
    my @opts = ($self->nprocs, $self->hostfile);
    $tabstop = 4; 

    push @opts, $self->env($self->_env)->@* if $self->has_env; 

    return ['mpirun_rsh', expand(map "\t".$_, @opts)]
};  

__PACKAGE__->meta->make_immutable;

1
