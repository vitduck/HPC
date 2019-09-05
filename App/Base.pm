package HPC::Benchmark::Base; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str/; 

has 'bin' => ( 
    is     => 'rw',
    isa    => Str,
    writer => 'set_bin'
); 

1
