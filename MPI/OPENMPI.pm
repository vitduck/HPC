package HPC::MPI::OPENMPI; 

use Text::Tabs; 
use Moose; 
use MooseX::Types::Moose     qw(HashRef); 
use HPC::MPI::Types::OPENMPI qw(OMP_OPENMPI ENV_OPENMPI MCA_OPENMPI); 
use namespace::autoclean; 

with qw(HPC::MPI::Base); 

has '+omp' => ( 
    isa    => OMP_OPENMPI, 
    coerce => 1
); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env(
            PSM2_MQ_RNDV_HFI_THRESH => $self->eagersize, 
            PSM2_MQ_RNDV_HFI_WINDOW => $self->eagersize,
            PSM2_MG_RNDV_SHM_THRESH => $self->eagersize, 
        ); 
    }
); 

has '+env' => ( 
    isa    => ENV_OPENMPI, 
    coerce => 1
); 

has '_mca' => (
    is       => 'rw',
    isa      => HashRef,
    traits   => ['Hash'],
    init_arg => undef,
    default  => sub {{}},
    handles  => {
        has_mca   => 'count',
        get_mca   => 'get',
        set_mca   => 'set',
        unset_mca => 'delete',
        reset_mca => 'clear',
        list_mca  => 'keys',
    }
);

has 'mca' => (
    is       => 'rw',
    isa      => MCA_OPENMPI,
    coerce   => 1,
    init_arg => undef,
    default  => sub {{}}, 
);


sub mpirun { 
    my $self = shift; 
    my @opts = (); 
    $tabstop = 4; 

    push @opts, $self->omp                  if $self->has_omp; 
    push @opts, $self->mca($self->_mca)->@* if $self->has_mca; 
    push @opts, $self->env($self->_env)->@* if $self->has_env; 

    return ['mpirun', expand(map "\t".$_, @opts)]
};  

__PACKAGE__->meta->make_immutable;

1
