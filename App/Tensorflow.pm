package HPC::App::Tensorflow; 

use Moose; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor;
use MooseX::XSAccessor; 
use HPC::Types::App::Tensorflow 'Cnn'; 
use Text::Tabs; 
use namespace::autoclean; 

use feature 'signatures'; 
no warnings 'experimental::signatures'; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd
    HPC::App::Tensorflow::Model
    HPC::App::Tensorflow::Device
    HPC::App::Tensorflow::Kmp
    HPC::App::Tensorflow::Threads ); 

has '+bin' => ( 
    isa    => Cnn, 
    coerce => 1 
); 

sub cmd {
    $tabstop = 4;
    my $self = shift;
    my @opts = ();

    # flatten cmd options
    for ($self->_get_opts) {
        my $has = "_has_$_";

        if ($self->$has) {
            push @opts, "\t--".$_.'='. $self->$_
        }
    }

    return [$self->bin, expand(@opts)]
}

sub _opts { 
    return qw(
        model data_format batch_size optimizer 
        device horovod_device variable_update local_parameter_device sync_on_finish
        mkl kmp_affinity kmp_blocktime kmp_settings 
        num_inter_threads num_intra_threads
        tfprof_file ); 
}

__PACKAGE__->meta->make_immutable;

1
