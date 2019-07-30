package HPC::MPI::MVAPICH2; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Lib'; 

has '+mpirun' => ( 
    default => 'mpirun_rsh'
); 

after qr/^(set|unset|reset)_env/ => sub { shift->_reset_env_opt };

sub _build_env_opt { 
    my $self = shift; 

    return 
        join(' ', map { $_.'='.$self->get_env($_) } $self->list_env)
} 

around 'cmd' => sub { 
    my ($cmd,$self,$omp) = @_; 

    my @opts = $self->$cmd; 
    push @opts, 'OMP_NUM_THREADS='.$omp if $omp > 1; 

    return @opts; 
}; 

__PACKAGE__->meta->make_immutable;

1
