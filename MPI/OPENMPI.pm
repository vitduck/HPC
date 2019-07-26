package HPC::MPI::OPENMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

sub _build_env_opt { 
    my $self = shift; 

    return 
        $self->has_env 
        ? join ' ', map { ('-x', join('=',$_, $self->get_env($_))) } $self->list_env 
        : undef
}

sub _build_omp_opt { 
    my $self = shift; 

    return 
        $self->omp != 1 
        ? join '=',"--map-by NUMA:PE", $self->omp 
        : undef
} 

__PACKAGE__->meta->make_immutable;

1
