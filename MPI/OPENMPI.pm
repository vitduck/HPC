package HPC::MPI::OPENMPI; 

use Moose; 
use HPC::MPI::Options qw(OMP_OPENMPI ENV_OPENMPI); 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

has '+omp' => ( 
    isa    => OMP_OPENMPI, 
    coerce => 1
); 

has '+env' => ( 
    isa    => ENV_OPENMPI, 
    coerce => 1
); 

after qr/^(set|unset|reset)_env/ => sub { 
    my $self = shift; 

    # update env
    $self->env($self->_env)
};  

__PACKAGE__->meta->make_immutable;

1
