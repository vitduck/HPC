package HPC::Mpi::Openmpi; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose 'HashRef'; 
use HPC::Types::Mpi::Openmpi qw(Report Map Bind); 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

with 'HPC::Mpi::Base'; 

has '+omp' => ( 
    trigger => sub ($self, $omp, @) { 
        $self->map("numa:pe=$omp")
    } 
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        if    ( $debug == 0 ) { $self->_reset_report && $self->unset_mca('mpi_show_mca_params')  }  
        elsif ( $debug == 4 ) { $self->report(1)                                                 } 
        elsif ( $debug == 5 ) { $self->debug(4) && $self->set_mca(mpi_show_mca_params => 'all') }

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
    trigger  => sub ($self, $pin, @) { 
        $self->_reset_bind; 
        $self->_reset_map; 

        for ($pin) { 
            if    ($pin eq 'bunch'  ) { $self->map('core') && $self->bind('core') } 
            elsif ($pin eq 'compact') { $self->map('numa') && $self->bind('core') } 
            elsif ($pin eq 'scatter') { $self->bind('core')                       } 
            elsif ($pin eq 'none'   ) { $self->bind('none')                       } 
            elsif ($pin == 0        ) { $self->bind('none')                       }
        } 
    } 
); 

has '+bind' => ( 
    isa    => Bind, 
    coerce => 1,
); 

has '+map' => (
    isa    => Map, 
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
          has_mca => 'count',
         list_mca => 'keys', 
          get_mca => 'get', 
          set_mca => 'set', 
        unset_mca => 'delete' 
    }, 
);

has 'report' => ( 
    is        => 'rw', 
    isa       => Report, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_report',
    clearer   => '_reset_report',
    coerce    => 1, 
    lazy      => 1, 
    default   => 1 
); 

sub _opts {
    return qw(report map bind)  
}; 

around 'cmd' => sub ($cmd, $self) { 
    my ($bin, $opt) = $self->$cmd->%*;  

    push $opt->@*, map { '-mca '.$_.'='.$self->get_mca($_) } sort $self->list_mca if $self->has_mca;
    push $opt->@*, map {   '-x '.$_.'='.$self->get_env($_) } sort $self->list_env if $self->has_env;

    return { $bin => $opt }
};

__PACKAGE__->meta->make_immutable;

1
