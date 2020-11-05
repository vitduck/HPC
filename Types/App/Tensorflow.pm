package HPC::Types::App::Tensorflow;  

use MooseX::Types::Moose qw(Str HashRef); 
use MooseX::Types -declare => [qw(Cnn Nccl)]; 

use HPC::App::Nccl; 

subtype    Cnn,  as Str, where { /^python/                 }; 
class_type Nccl,               { class => 'HPC::App::Nccl' }; 

coerce Cnn,  from Str,      via { 'python ' .$_               }; 
coerce Nccl, from HashRef , via { HPC::App::Nccl->new($_->%*) }; 

1
