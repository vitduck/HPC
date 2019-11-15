package HPC::Mpi::Impi;  

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Int Str); 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

with 'HPC::Mpi::Base'; 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        $debug == 1 
        ? $self->set_env(
            I_MPI_DEBUG        => 5, 
            I_MPI_HYHDRA_DEBUG => 1
        ) 
        : $self->unset_env(
            'I_MPI_DEBUG',
            'I_MPI_HYDRA_DEBUG'
        )
    } 
); 

has '+eager' => (
    lazy    => 1,
    default => '256KB',
    trigger => sub ($self, $size, @) { 
        $self->set_env(
            I_MPI_EAGER_THRESHOLD => $size
        )
    }
);

has 'fabrics' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef,
    traits   => ['Chained'],
    lazy     => 1, 
    default  => 'shm:mpi',
    trigger  => sub ($self, $fabric, @) { 
        my $provider = join('_', 'I_MPI', uc((split /:/, $fabric)[1]), 'PROVIDER');  

        $self->set_env(
            I_MPI_FABRICS  => $fabric, 
            $provider      => 'psm2',
            I_MPI_FALLBACK => 0
        ) 
    }
); 

sub _opts { 
    return ()
} 

around 'cmd' => sub ($cmd, $self) { 
    my ($bin, $opt) = $self->$cmd->%*;  

    push $opt->@*,  
        map { '-env '.$_.'='.$self->get_env($_) } sort $self->list_env if $self->has_env; 
    
    return { $bin => $opt }
};  

__PACKAGE__->meta->make_immutable;

1
