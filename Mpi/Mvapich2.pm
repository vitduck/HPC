package HPC::Mpi::Mvapich2; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Str Int); 
use HPC::Types::Mpi::Mvapich2 'Env'; 

use namespace::autoclean; 
use experimental qw(signatures switch);

with 'HPC::Mpi::Base'; 

has '+bin' => ( 
    default => 'mpirun_rsh' 
); 

has '+hostfile' => ( 
    lazy => 0 
); 

has '+nprocs' => ( 
    lazy => 0 
); 

# assume no hyper-threading
has '+omp' => ( 
    trigger => sub ($self, $omp, @) { 
        $self->set_env( 
            MV2_THREADS_PER_PROCESS => $omp,
            OMP_NUM_THREADS         => $omp 
        ); 

        # use 'bunch' by default
        $self->pin
    }
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        for ($debug) {  
            when (4) { $self->set_env(MV2_SHOW_ENV_INFO => 1,MV2_SHOW_CPU_BINDING => 1) } 
            when (5) { $self->set_env(MV2_SHOW_ENV_INFO => 2,MV2_SHOW_CPU_BINDING => 1) } 
            when (0) { $self->unset_env('MV2_SHOW_ENV_INFO', 'MV2_SHOW_CPU_BINDING')    } 
        }
    } 
); 

has '+pin' => ( 
    isa     => Str, 
    lazy    => 1,
    default => 'bunch',
    trigger => sub ($self, $pin, @) { 
        for ($pin) { 
            when ('bunch'  ) { $self->set_env(MV2_ENABLE_AFFINITY => 1, MV2_CPU_BINDING_POLICY => 'bunch'  ) } 
            when ('scatter') { $self->set_env(MV2_ENABLE_AFFINITY => 1, MV2_CPU_BINDING_POLICY => 'scatter') } 
            when ('none'   ) { $self->set_env(MV2_ENABLE_AFFINITY => 0); 
                               $self->unset_env('MV2_CPU_BINDING_POLICY'); 
                               $self->_unset_pin }
        }
    } 
); 

has '+eagersize' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env( MV2_SMP_EAGERSIZE => $size )
    }
); 

has '+env_opt' => ( 
    isa       => Env, 
    coerce    => 1,
); 

sub _opts { 
    return qw(nprocs hostfile env_opt)
}; 

__PACKAGE__->meta->make_immutable;

1
