package HPC::Mpi::Openmpi; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose 'HashRef'; 
use HPC::Types::Mpi::Openmpi qw(Report Map Bind Env Mca); 

use namespace::autoclean; 
use experimental qw(signatures switch);

with 'HPC::Mpi::Base'; 

has '+nprocs' => ( 
    trigger => sub ($self, @) { 
        $self->pin($self->pin) if $self->_has_pin; 
    } 
); 

has '+omp' => ( 
    trigger => sub ($self, $omp, $=) {
        $self->bind('core')->map('numa:pe='.$self->omp)
    }
);

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        given ($debug) { 
            when (0) { 
                $self->_unset_report; 
                $self->unset_mca('mpi_show_mca_params') }  

            when (4) { 
                $self->report(1) }                     

            when (5) { 
                $self->report(1); 
                $self->set_mca(mpi_show_mca_params => 'all') } 
        }
    }
);

has '+eagersize' => ( 
    trigger => sub ($self, $size, @) { 
        $self->set_env(
            PSM2_MQ_RNDV_HFI_THRESH => $size, 
            PSM2_MQ_RNDV_HFI_WINDOW => $size,
        ); 
    } 
); 

has '+pin' => ( 
    lazy    => 1, 
    default => 'none',
    trigger  => sub ($self, $pin, @) { 
        given ($pin) { 
            when ('none') { 
                $self->bind('none')->_unset_map  } 

            when ('bunch'  ) { 
                $self->bind('core')->map('core') }

            when ('compact') { 
                $self->bind('core')->map('numa') }

            when ('default') { 
                $self->_unset_bind;
                $self->_unset_map } 
            
            when ('scatter') { 
                $self->nprocs > 2 
                    ? $self->bind('core')->_unset_map
                    : $self->bind('core')->map('numa') }
        } 
    } 
); 

has '+bind' => ( 
    isa     => Bind, 
    coerce  => 1,
    lazy    => 1, 
    default => 'none'
); 

has '+map' => (
    isa     => Map, 
    coerce  => 1, 
    lazy    => 1, 
    default => 'socket'
); 

has '+env_opt' => ( 
    isa       => Env, 
    coerce    => 1,
); 

has 'mca' => (
    is       => 'rw',
    isa      => HashRef,
    traits   => [qw(Chained Hash)],
    init_arg => undef,
    lazy     => 1, 
    default  => sub {{}},
    handles  => { 
          has_mca => 'count',
         list_mca => 'keys', 
          get_mca => 'get', 
          set_mca => 'set', 
        unset_mca => 'delete' 
    }, 
    trigger  => sub ($self, $mca, @) { 
        $self->has_mca 
        ? $self->mca_opt($mca)
        : $self->_unset_mca_opt
    } 
);

has mca_opt => ( 
    is        => 'rw', 
    isa       => Mca, 
    init_arg  => undef,
    predicate => '_has_mca_opt',
    clearer   => '_unset_mca_opt',
    coerce    => 1,
    lazy      => 1, 
    default   => sub {{}},  
); 

has 'report' => ( 
    is        => 'rw', 
    isa       => Report, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_report',
    clearer   => '_unset_report',
    coerce    => 1, 
    lazy      => 1, 
    default   => 1 
); 

sub _opts {
    return qw(bind map report mca_opt env_opt)  
}; 

__PACKAGE__->meta->make_immutable;

1
