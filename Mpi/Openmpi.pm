package HPC::Mpi::Openmpi; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose 'HashRef'; 
use HPC::Types::Mpi::Openmpi 'Omp' ; 
use namespace::autoclean; 
use feature 'signatures';
no warnings 'experimental::signatures';

with 'HPC::Mpi::Base'; 

has '+omp' => ( 
    isa    => Omp, 
    coerce => 1 
); 

has '+debug' => ( 
    trigger  => sub ($self, $debug, @) {
        $debug == 1 
        ? $self->set_mca(
            # mpi_show_handle_leaks => 1, 
            mpi_show_mca_params   => 'all' 
        )
        : $self->unset_mca(
            #'mpi_show_handle_leaks',
            'mpi_show_mca_params'
        )
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

sub _opts {
    return qw(omp )  
}; 

around 'cmd' => sub ($cmd, $self) { 
    my ($bin, $opt) = $self->$cmd->%*;  

    push $opt->@*,  
        map {   '-x '.$_.'='.$self->get_env($_) } sort $self->list_env if $self->has_env;
    
    push $opt->@*,  
        map { '-mca '.$_.'='.$self->get_mca($_) } sort $self->list_mca if $self->has_mca;

    return { $bin => $opt }
};

__PACKAGE__->meta->make_immutable;

1
