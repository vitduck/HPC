package HPC::Mpi::Impi;  

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Int Str); 
use HPC::Types::Mpi::Impi 'Pin'; 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

with 'HPC::Mpi::Base'; 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        if    ( $debug == 0 ) { $self->unset_env('I_MPI_DEBUG', 'I_MPI_HYDRA_DEBUG')     }  
        elsif ( $debug == 4 ) { $self->set_env(I_MPI_DEBUG => 4)                         }  
        elsif ( $debug == 5 ) { $self->set_env(I_MPI_DEBUG => 5, I_MPI_HYDRA_DEBUG => 1) }  
    } 
); 

has '+eagersize' => (
    lazy    => 1,
    default => '256KB',
    trigger => sub ($self, $size, @) { 
        $self->set_env(I_MPI_EAGER_THRESHOLD => $size)
    }
);

has '+pin' => ( 
    isa     => Pin, 
    coerce  => 1, 
    trigger => sub ($self, $pin, @) { 
        if ($pin == 0) { 
            $self->set_env(I_MPI_PIN => 0); 
            $self->unset_env('I_MPI_PIN_PROCS_LIST');   
        } else { 
            $self->set_env(I_MPI_PIN => 1); 
            $self->set_env(I_MPI_PIN_PROCS_LIST => $pin) 
        }
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
            $provider      => $self->fabric_provider,
            I_MPI_FALLBACK => 0
        ) 
    }
); 

has 'fabric_provider' => ( 
    is       => 'rw', 
    isa      => Str,
    init_arg => undef,
    traits   => ['Chained'],
    default  => 'psm2',
); 

sub _opts { 
    return ()
} 

around 'cmd' => sub ($cmd, $self) { 
    my ($bin, $opt) = $self->$cmd->%*;  

    push $opt->@*, map { '-env '.$_.'='.$self->get_env($_) } sort $self->list_env if $self->has_env; 
    
    return { $bin => $opt }
};  

__PACKAGE__->meta->make_immutable;

1
