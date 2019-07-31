package HPC::MPI::MVAPICH2; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

has '+mpirun' => ( 
    default => 'mpirun_rsh'
); 

sub omp_opt { 
    my $self = shift; 

    return join('=', 'OMP_NUM_THREADS', $self->omp ); 
} 

sub env_opt { 
    my $self = shift; 

    return
        join ' ',
        map { $_.'='.$self->get_env($_) } $self->list_env; 
} 

around 'opt' => sub { 
    my ($opt, $self) = @_; 
    
    return (
        $self->nprocs, 
        $self->hostfile, 
        $self->$opt
    )
};  

__PACKAGE__->meta->make_immutable;

1
