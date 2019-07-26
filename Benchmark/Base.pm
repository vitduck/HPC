package HPC::Benchmark::Base; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str Bool/; 

has 'bin' => ( 
    is  => 'rw',
    isa => Str,
); 

has 'aps' => ( 
    is      => 'rw', 
    isa     => Bool, 
    traits  => ['Bool'],
    lazy    => 1, 
    default => 0, 
    handles => { 
        enable_aps => 'set', 
        diable_aps => 'unset'
    } 
); 

1
