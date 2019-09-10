package HPC::MPI::OPENMPI; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
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

has '+env_opt' => ( 
    isa    => ENV_OPENMPI, 
    coerce => 1
); 

has 'mca' => (
    is       => 'rw',
    isa      => HashRef,
    traits   => [qw(Chained Hash)],
    init_arg => undef,
    lazy     => 1, 
    clearer  => 'reset_mca',
    default  => sub {{}},
    handles  => {
        set_mca   => 'set',
        unset_mca => 'delete',
    }
);

has 'mca_opt' => (
    is        => 'rw',
    isa       => MCA_OPENMPI,
    coerce    => 1,
    clearer   => '_unset_mca_opt',
    predicate => '_has_mca_opt',
    init_arg  => undef,
    lazy      => 1, 
    default   => sub {{}}, 
);

after [qw(set_mca unset_mca)] => sub {
    my $self = shift;

    $self->mca_opt($self->mca)
};

after 'reset_mca' => sub {
    my $self = shift;

    $self->_unset_mca_opt
};

override _get_opts => sub { 
    return qw(omp env_opt mca_opt)  
}; 

__PACKAGE__->meta->make_immutable;

1
