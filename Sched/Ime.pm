package HPC::Sched::Ime; 

use Moose::Role; 
use MooseX::Types::Moose 'ArrayRef'; 

use HPC::Types::Sched::Ime qw(Ime_Stage Ime_Sync); 

use namespace::autoclean; 
use experimental 'signatures';  

has 'ime_stage' => ( 
    is        => 'rw', 
    isa       => Ime_Stage, 
    traits    => ['Chained'],
    init_arg  => undef,
    coerce    => 1, 
);

has 'ime_sync' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    isa       => Ime_Sync, 
    init_arg  => undef,
    coerce    => 1, 
);

1 
