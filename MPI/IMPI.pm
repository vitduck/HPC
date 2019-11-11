package HPC::MPI::IMPI;  

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Int Str); 

use HPC::MPI::Types::IMPI 'ENV_IMPI'; 

use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

extends 'HPC::MPI::Base';  

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        $debug == 1 
        ? $self->set_env(
            I_MPI_DEBUG        => 5, 
            I_MPI_HYHDRA_DEBUG => 1,
        ) 
        : $self->unset_env(qw(
            I_MPI_DEBUG 
            I_MPI_HYDRA_DEBUG
        ))
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

has '+env_opt' => (
    isa     => ENV_IMPI, 
    coerce  => 1 
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

override _get_opts => sub ($self) { 
    return qw(env_opt); 
}; 

__PACKAGE__->meta->make_immutable;

1
