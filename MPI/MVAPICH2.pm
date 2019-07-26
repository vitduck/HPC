package HPC::MPI::MVAPICH2;  

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

has '+mpirun' => ( 
    default => sub { 
        join ' ', qw/mpirun_rsh -np ${TOTAL_CPUS} -hostfile $PBS_NODEFILE/
    }
); 

sub _build_env_opt { 
    my $self = shift; 

    return 
        $self->has_env 
        ? join ' ', map { join('=',$_, $self->get_env($_)) } $self->list_env 
        : undef
}

sub _build_omp_opt { 
    my $self = shift; 

    return 
        $self->omp != 1 
        ? join '=',"OMP_NUM_THREADS", $self->omp 
        : undef
} 

around 'cmd' => sub { 
    my ($cmd, $self) = @_; 

    return 
        "TOTAL_CPUS=\$(wc -l \$PBS_NODEFILE | awk '{print \$1}')\n\n". $self->$cmd
};  

__PACKAGE__->meta->make_immutable;

1
