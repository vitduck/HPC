package HPC::Mpi::Openmpi; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose 'HashRef'; 
use HPC::Types::Mpi::Openmpi qw(Report Map Bind Env Mca); 
use namespace::autoclean; 
use feature qw(signatures switch);
no warnings qw(experimental::signatures experimental::smartmatch); 

with 'HPC::Mpi::Base'; 

# has '+omp' => ( 
    # trigger => sub ($self, @) { 
        # $self->bind; 
        # $self->map
    # } 
# ); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        for ($debug) { 
            when (4) { $self->report(1)                                               } 
            when (5) { $self->report(1); $self->set_mca(mpi_show_mca_params => 'all') }
            when (0) { $self->_unset_report; $self->unset_mca('mpi_show_mca_params')  }  
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
        $self->_unset_bind; 
        $self->_unset_map; 

        for ($pin) { 
            when ('bunch'  ) { $self->map('core')->bind('core') } 
            when ('compact') { $self->map('numa')->bind('core') } 
            when ('scatter') { $self->bind('core')              } 
            when ('none'   ) { $self->bind('none')              } 
        } 
    } 
); 

has '+bind' => ( 
    isa     => Bind, 
    coerce  => 1,
    lazy    => 1, 
    default => 'core'
); 

has '+map' => (
    isa     => Map, 
    coerce  => 1, 
    lazy    => 1, 
    default => 'core'
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
    return qw(map bind report mca_opt env_opt)  
}; 

__PACKAGE__->meta->make_immutable;

1
