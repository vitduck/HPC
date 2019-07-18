package HPC::Benchmark::Base; 

use Moose::Role; 

requires '_build_cmd'; 

has 'inp' => ( 
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_inp'
);

has 'out' => ( 
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_out'
);

has 'bin' => ( 
    is  => 'rw',
    isa => 'Str',
); 

has 'cmd' => ( 
    is       => 'rw', 
    isa      => 'Str', 
    lazy     => 1, 
    clearer  => '_reset_cmd', 
    builder  => '_build_cmd'
);

1
