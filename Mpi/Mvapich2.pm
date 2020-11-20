package HPC::Mpi::Mvapich2; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Str Int ArrayRef); 
use HPC::Types::Mpi::Mvapich2 'Env'; 
use HPC::Types::Mpi::Base qw(Nprocs Hostfile); 

use namespace::autoclean; 
use experimental qw(signatures switch);

with 'HPC::Mpi::Base'; 

has '+bin' => ( 
    default => 'mpirun_rsh' 
); 

has '+hostfile' => ( 
    isa     => Hostfile,
    coerce  => 1, 
); 

has '+nprocs' => ( 
    isa     => Nprocs,
    coerce  => 1, 
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
        given ($debug) {  
            when (0) { 
                $self->unset_env(
                    'MV2_SHOW_ENV_INFO', 
                    'MV2_SHOW_CPU_BINDING') } 
            when (4) { 
                $self->set_env(
                    MV2_SHOW_ENV_INFO    => 1,
                    MV2_SHOW_CPU_BINDING => 1) } 
            when (5) { 
                $self->set_env(
                    MV2_SHOW_ENV_INFO    => 2,
                    MV2_SHOW_CPU_BINDING => 1) } 
                    }
    } 
); 

has '+pin' => ( 
    isa     => Str, 
    lazy    => 1,
    default => 'bunch',
    trigger => sub ($self, $pin, @) { 
        given ($pin) { 
            when ('none') { 
                $self->_unset_pin; 
                $self->unset_env('MV2_CPU_BINDING_POLICY'); 
                $self->set_env  (MV2_ENABLE_AFFINITY => 0) } 
            when ('bunch') { 
                $self->set_env(
                    MV2_ENABLE_AFFINITY    => 1, 
                    MV2_CPU_BINDING_POLICY => 'bunch') } 
            when ('scatter') { 
                $self->set_env(
                    MV2_ENABLE_AFFINITY    => 1, 
                    MV2_CPU_BINDING_POLICY => 'scatter') } 
        }
    } 
); 

has '+eagersize' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env( 
            MV2_SMP_EAGERSIZE => $size 
        )
    }
); 

has '+env_opt' => ( 
    isa       => Env, 
    coerce    => 1,
); 

has 'cuda' => ( 
    is       => 'rw', 
    isa      => Int, 
    lazy     => 1, 
    default  => 0, 
    trigger  => sub ($self, $cuda, $=) { 
        $cuda == 1 ? $self->set_env(MV2_USE_CUDA => 1) : $self->set_env(Mv2_USE_CUDA => 0)
    } 
); 

has 'rail' => ( 
    is      => 'rw', 
    isa     => ArrayRef, 
    lazy    => 1, 
    default => sub {[]}, 
    trigger => sub ($self, $rail, $=) {  
        $self->set_env(MV2_PROCESS_TO_RAIL_MAPPING => join(':', $rail->@*))
    } 
); 

has 'gdrcopy' => (  
    is      => 'rw', 
    isa     => Str, 
    lazy    => 1, 
    default => '', 
    trigger => sub ($self, $gdrcopy, $=) { 
        $self->set_env(MV2_GPUDIRECT_GDRCOPY_LIB => '/apps/common/gdrcopy/2.1/lib64/libgdrapi.so')
    } 
); 

sub _opts { 
    return qw(nprocs hostfile env_opt)
}; 

__PACKAGE__->meta->make_immutable;

1
