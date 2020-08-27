package HPC::Mpi::Impi;  

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Int Str); 
use HPC::Types::Mpi::Impi 'Env'; 
use namespace::autoclean; 
use feature qw(signatures switch);
no warnings qw(experimental::signatures experimental::smartmatch); 

with 'HPC::Mpi::Base'; 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        for ($debug) { 
            when (4) { $self->set_env(I_MPI_DEBUG => 4)                         } 
            when (5) { $self->set_env(I_MPI_DEBUG => 5, I_MPI_HYDRA_DEBUG => 1) }  
            when (0) { $self->unset_env('I_MPI_DEBUG', 'I_MPI_HYDRA_DEBUG')     } 
        }
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
    isa     => Str, 
    lazy    => 1, 
    default => 'bunch',
    trigger => sub ($self, $pin, @) { 
        for ($pin) { 
            when ('bunch'  ) { $self->set_env(I_MPI_PIN => 1, I_MPI_PIN_PROCS_LIST => 'allcores:grain=fine:shift=1') } 
            when ('spread' ) { $self->set_env(I_MPI_PIN => 1, I_MPI_PIN_PROCS_LIST => 'allcores:map=spread')         } 
            when ('scatter') { $self->set_env(I_MPI_PIN => 1, I_MPI_PIN_PROCS_LIST => 'allcores:map=scatter')        } 
            when ('none'   ) { $self->set_env(I_MPI_PIN => 0); $self->unset_env('I_MPI_PIN_PROCS_LIST')              }    
        }
    }
);

has '+env_opt' => ( 
    isa       => Env, 
    coerce    => 1,
); 

# has 'fabrics' => (
    # is       => 'rw', 
    # isa      => Str, 
    # init_arg => undef,
    # traits   => ['Chained'],
    # lazy     => 1, 
    # default  => 'shm:mpi',
    # trigger  => sub ($self, $fabric, @) { 
        # my $provider = join('_', 'I_MPI', uc((split /:/, $fabric)[1]), 'PROVIDER');  

        # $self->set_env(
            # I_MPI_FALLBACK => 0, 
            # I_MPI_FABRICS  => $fabric, 
            # $provider      => $self->fabric_provider,
        # ) 
    # }
# ); 

# has 'fabric_provider' => ( 
    # is       => 'rw', 
    # isa      => Str,
    # init_arg => undef,
    # traits   => ['Chained'],
    # default  => 'psm2',
# ); 

sub _opts { 
    return ('env_opt')
} 

__PACKAGE__->meta->make_immutable;

1
