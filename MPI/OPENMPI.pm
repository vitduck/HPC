package HPC::MPI::OPENMPI; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw(HashRef); 
use HPC::MPI::Types::OPENMPI qw(OMP_OPENMPI ENV_OPENMPI MCA_OPENMPI); 
use namespace::autoclean; 

extends qw(HPC::MPI::Base); 

has '+omp' => ( 
    isa    => OMP_OPENMPI, 
    coerce => 1, 
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
    lazy     => 1, 
    default  => sub {{}},
    handles  => {
        set_mca   => 'set',
        unset_mca => 'delete',
        reset_mca => 'clear',
    }
);

has 'mca' => (
    is       => 'rw',
    isa       => MCA_OPENMPI,
    coerce    => 1,
    init_arg  => undef,
    reader    => 'get_mca', 
    predicate => '_has_mca',
    lazy      => 1, 
    default   => sub {{}}, 
);

override _get_opts => sub { 
    return qw(omp env mca)  
}; 

__PACKAGE__->meta->make_immutable;

1
