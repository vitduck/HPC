package HPC::App::Tensorflow; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use HPC::App::Types::Tensorflow qw(Cnn); 
use Text::Tabs; 
use namespace::autoclean; 

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data 
    HPC::App::Tensorflow::Model
    HPC::App::Tensorflow::Device
    HPC::App::Tensorflow::Kmp
    HPC::App::Tensorflow::Threads
); 

has '+bin' => ( 
    isa    => Cnn, 
    coerce => 1,
); 

sub cmd {
    $tabstop = 4;
    my $self = shift;
    my @opts = ();

    # flatten cmd options
    for ($self->_get_opts) {
        my $has = "_has_$_";

        if ($self->$has and $self->$_) {
            push @opts, "\t--".$_.'='. $self->$_
        }
    }

    return [$self->bin, expand(@opts)]
}

sub _get_opts { 
    return qw(
        model data_format batch_size optimizer 
        device horovod_device variable_update local_parameter_device sync_on_finish
        mkl kmp_affinity kmp_blocktime kmp_settings 
        num_inter_threads num_intra_threads
    ); 
}

__PACKAGE__->meta->make_immutable;

1
