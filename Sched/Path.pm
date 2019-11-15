package HPC::Sched::Path; 

use Env qw(@LD_LIBRARY_PATH); 
use Moose::Role; 
use MooseX::Types::Moose 'ArrayRef'; 

has '_ld_library_path' => ( 
    is       => 'rw',
    isa      => ArrayRef, 
    traits   => ['Array'], 
    init_arg => undef, 
    lazy     => 1, 
    clearer  => '_reset_ld_library_path', 
    default  => sub { \@LD_LIBRARY_PATH },
); 

1 
