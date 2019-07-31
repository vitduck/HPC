package HPC::MPI::IMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

sub omp_opt { 
    my $self = shift; 

    return undef
} 

sub env_opt { 
    my $self = shift; 

    return
        join ' ',
        map { ('-env', $_) }
        map { $_.'='.$self->get_env($_) } $self->list_env; 
} 

__PACKAGE__->meta->make_immutable;

1
