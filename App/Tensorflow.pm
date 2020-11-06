package HPC::App::Tensorflow; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::StrictConstructor;
use MooseX::Attribute::Chained; 

use HPC::App::Nccl; 
use HPC::Types::App::Tensorflow qw(Cnn Nccl); 

use namespace::autoclean; 
use experimental 'signatures'; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd
    HPC::App::Tensorflow::Model
    HPC::App::Tensorflow::Device
    HPC::App::Tensorflow::Gpu
    HPC::App::Tensorflow::Cpu
    HPC::App::Tensorflow::Threads
); 

has '+bin' => ( 
    isa    => Cnn, 
    coerce => 1 
); 

has 'nccl' => ( 
    is        => 'rw', 
    isa       => Nccl,
    predicate => '_has_nccl',
    coerce    => 1,
    lazy      => 1, 
    default   => sub {{}}, 
    handles   => { 
        _list_nccl_env => 'list_env', 
         _get_nccl_env => 'get_env'
    }
); 

sub cmd {
    my $self = shift;
    my @opts = ();

    # flatten cmd options
    for ($self->_opts) {
        my $has = "_has_$_";

        if ($self->$has) { 
            push @opts, 
                /allow_growth|use_fp16/ 
                ? '--'.$_
                : '--'.$_.'='.$self->$_ 
        }
    }

    return { $self->bin, [@opts] } 
}

sub _opts { 
    return qw(
        model batch_size optimizer data_format  
        device horovod_device variable_update local_parameter_device sync_on_finish
        use_fp16 allow_growth
        mkl kmp_affinity kmp_blocktime kmp_settings 
        num_inter_threads num_intra_threads
        data_name data_dir train_dir tfprof_file); 
}

__PACKAGE__->meta->make_immutable;

1
