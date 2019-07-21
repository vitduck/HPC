package HPC::App::Base; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str/; 

has 'bin' => ( 
    is      => 'rw',
    isa     => Str,
); 

1
