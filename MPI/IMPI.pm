package HPC::MPI::IMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Lib'; 

after qr/^(set|unset|reset)_env/ => sub { shift->_reset_env_opt };

sub _build_env_opt { 
    my $self = shift; 

    return 
        join(' ', map { ('-env', $_.'='.$self->get_env($_)) } $self->list_env)
} 

__PACKAGE__->meta->make_immutable;

1
