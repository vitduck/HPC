package HPC::Mpi::Mvapich2; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
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

has '+omp' => ( 
    trigger => sub ($self, $omp, @) { 
        $self->set_env( 
            OMP_NUM_THREADS         => $omp,  
            MV2_THREADS_PER_PROCESS => $omp, 
            MV2_ENABLE_AFFINITY     => 1,
            MV2_CPU_BINDING_POLICY  => 'hybrid'
        ); 
    }
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        if    ( $debug == 0 ) { $self->unset_env('MV2_SHOW_ENV_INFO', 'MV2_SHOW_CPU_BINDING') } 
        elsif ( $debug == 4 ) { $self->set_env(MV2_SHOW_CPU_BINDING  => 1)                    } 
        elsif ( $debug == 5 ) { $self->debug(4) && $self->set_env(MV2_SHOW_ENV_INFO => 2)     } 
    } 
); 

has '+pin' => ( 
    isa     => Pin, 
    coerce  => 1, 
    trigger => sub ($self, $pin, @) { 
        unless ($pin =~ /0/) { 
            $self->set_env(MV2_ENABLE_AFFINITY    => 1);         
            $self->set_env(MV2_CPU_BINDING_POLICY => $pin)
        } 
    } 
); 

has '+eagersize' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env( MV2_SMP_EAGERSIZE => $size )
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
