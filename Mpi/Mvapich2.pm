package HPC::Mpi::Mvapich2; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose 'Int'; 
use HPC::Types::Mpi::Mvapich2 'Pin'; 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

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
        # default binding 
        if ( $omp ) { 
            $self->set_env( 
                OMP_NUM_THREADS         => $omp,  
                MV2_THREADS_PER_PROCESS => $omp, 
                MV2_ENABLE_AFFINITY     => 1,
                MV2_CPU_BINDING_POLICY  => 'bunch', 
            ); 
        }
    }
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        if    ( $debug == 0 ) { $self->unset_env('MV2_SHOW_ENV_INFO', 'MV2_SHOW_CPU_BINDING') } 
        elsif ( $debug == 4 ) { $self->set_env(MV2_SHOW_CPU_BINDING  => 1) } 
        elsif ( $debug == 5 ) { $self->debug(4); 
                                $self->set_env(MV2_SHOW_ENV_INFO => 2) } 
    } 
); 

has '+pin' => ( 
    isa     => Pin, 
    coerce  => 1, 
    trigger => sub ($self, $pin, @) { 
        if ( $pin eq 'none' ) { $self->set_env(MV2_ENABLE_AFFINITY    => 0) } 
        else                  { $self->set_env(MV2_ENABLE_AFFINITY    => 1, 
                                               MV2_CPU_BINDING_POLICY => $pin) }
    } 
); 

has '+eagersize' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env( MV2_SMP_EAGERSIZE => $size )
    }
); 

has 'rdma' => ( 
    is       => 'rw',
    isa      => Int, 
    init_arg => undef,
    traits   => [ 'Chained' ], 
    lazy     => 1, 
    default  => 0,
    trigger  => sub ($self,@) { 
        $self->set_env(MV2_USE_GPUDIRECT_RDMA => $self->rdma)
    } 
); 

has 'gdrcopy' => ( 
    is       => 'rw',
    isa      => Int, 
    init_arg => undef,
    traits   => [ 'Chained' ],
    lazy     => 1, 
    default  => 0,
    trigger  => sub ($self,@) { 
        $self->set_env(MV2_USE_GDRCOPY => $self->gdrcopy)
    } 
); 

sub _opts { 
    return qw(nprocs hostfile)
}; 

around 'cmd' => sub ($cmd, $self) { 
    my ($bin, $opt) = $self->$cmd->%*;  

    push $opt->@*,  
        map { $_.'='.$self->get_env($_) } sort $self->list_env if $self->has_env; 
    
    return { $bin => $opt }
};  

__PACKAGE__->meta->make_immutable;

1
