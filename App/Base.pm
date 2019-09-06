package HPC::App::Base; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str/; 

requires 'cmd'; 

has 'bin' => ( 
    is     => 'rw',
    isa    => Str,
    writer => 'set_bin'
); 

1
