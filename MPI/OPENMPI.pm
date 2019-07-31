package HPC::MPI::OPENMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

sub omp_opt { 
    my $self = shift; 

    return (join '=', '--map-by NUMA:PE', $self->omp)
} 

sub env_opt { 
    my $self = shift; 

    return
        join ' ',
        map { ('-x', $_) }
        map { $_.'='.$self->get_env($_) } $self->list_env; 
} 

__PACKAGE__->meta->make_immutable;

1
