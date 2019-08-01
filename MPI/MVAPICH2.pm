package HPC::MPI::MVAPICH2; 

use Moose; 
use HPC::MPI::Options qw(OMP_MVAPICH2 ENV_MVAPICH2); 
use namespace::autoclean; 

with 'HPC::MPI::MPI'; 

has '+mpirun' => ( 
    default => 'mpirun_rsh'
); 

has '+omp' => ( 
    isa    => OMP_MVAPICH2, 
    coerce => 1
); 

has '+env' => ( 
    isa    => ENV_MVAPICH2, 
    coerce => 1
); 

after qr/^(set|unset|reset)_env/ => sub { 
    my $self = shift; 

    # update env
    $self->env($self->_env)
};  

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
