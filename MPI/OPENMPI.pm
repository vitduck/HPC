package HPC::MPI::OPENMPI; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(HashRef); 
use HPC::MPI::Types::OPENMPI qw(OMP_OPENMPI ENV_OPENMPI MCA_OPENMPI); 
use namespace::autoclean; 

use feature 'signatures';
no warnings 'experimental::signatures';

extends 'HPC::MPI::Base'; 

has '+omp' => ( 
    isa    => OMP_OPENMPI, 
    coerce => 1 
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        $debug == 1 
        ? $self->set_mca(
            mpi_show_handle_leaks => 1, 
            mpi_show_mca_params   => 'all' 
        )
        : $self->unset_mca(qw(
            mpi_show_handle_leaks
            mpi_show_mca_params 
        ))
    } 
); 

has '+eager' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env(
            PSM2_MQ_RNDV_HFI_THRESH => $size, 
            PSM2_MQ_RNDV_HFI_WINDOW => $size,
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
    clearer  => 'reset_mca',
    lazy     => 1, 
    default  => sub {{}},
    handles  => { 
        set_mca   => 'set', 
        unset_mca => 'delete' 
    }, 
    trigger  => sub ($self, $mca, @) { 
        $self->mca_opt($mca) 
    } 
);

has 'mca_opt' => (
    is        => 'rw',
    isa       => MCA_OPENMPI,
    init_arg  => undef,
    predicate => '_has_mca_opt',
    clearer   => '_unset_mca_opt',
    coerce    => 1,
    lazy      => 1, 
    default   => sub {{}}
);

override _get_opts => sub { 
    return qw(omp env_opt mca_opt)  
}; 

__PACKAGE__->meta->make_immutable;

1
