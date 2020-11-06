package HPC::Plugin::Tensorflow; 

use Moose::Role; 

use HPC::App::Tensorflow; 
use HPC::Types::Sched::Plugin 'Tensorflow'; 

use namespace::autoclean; 
use experimental 'signatures'; 

has 'tensorflow' => (
    is        => 'rw', 
    isa       => Tensorflow,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_tensorflow',
    coerce    => 1,  
    trigger  => sub ($self, $app, @) { 
        if ($self->tensorflow->_has_nccl) { 
            for my $nccl_env (sort $self->tensorflow->_list_nccl_env) { 
                $self->set_env(
                    $nccl_env => $self->tensorflow->_get_nccl_env($nccl_env)
                )
            }
        } 
    }
); 

1
