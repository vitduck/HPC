package HPC::PBS::Cmd; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str ArrayRef/; 

has 'cmd' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => ArrayRef[Str],
    lazy    => 1, 
    default => sub {["cd \$PBS_O_WORKDIR"]},
    handles => { 
         _add_cmd => 'push',
         list_cmd => 'elements' 
    }, 
    clearer => 'new_cmd', 
);

1
