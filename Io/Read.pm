package HPC::Io::Read; 

use Moose::Role; 

use HPC::Types::Io::Fh 'FH_Read'; 

has 'io_read' => ( 
    is       => 'rw', 
    isa      => FH_Read, 
    init_arg => undef,
    clearer  => '_close_io_read',
    coerce   => 1, 
    handles  => [qw(getline getlines)]
); 

1
