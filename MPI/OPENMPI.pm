package HPC::MPI::OPENMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Lib'; 

after qr/^(set|unset|reset)_env/ => sub { shift->_reset_env_opt };

sub _build_env_opt { 
    my $self = shift; 

    return 
        join(' ', map { ('-x', $_.'='.$self->get_env($_)) } $self->list_env)
} 

around 'cmd' => sub { 
    my ($cmd,$self,$omp) = @_; 
   
    my @opts = $self->$cmd; 
    push @opts, '--map-by NUMA:PE='.$omp; 

    return @opts; 
}; 

__PACKAGE__->meta->make_immutable;

1
