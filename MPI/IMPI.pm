package HPC::MPI::IMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

sub _build_env_opt { 
    my $self = shift; 

    return 
        $self->has_env 
        ? join ' ', map { ('-env', join('=',$_, $self->get_env($_))) } $self->list_env 
        : undef
}

sub _build_omp_opt { 
    return undef
} 

sub cmd { 
    my $self = shift; 
    
    return 
        join ' ', 
        grep $_, ($self->mpirun, $self->omp_opt, $self->env_opt)
}

1
