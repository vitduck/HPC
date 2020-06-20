package HPC::Io::Write; 

use Moose::Role; 
use HPC::Types::Io::Fh 'FH_Write'; 

has 'io_write' => ( 
    is       => 'rw', 
    isa      => FH_Write, 
    init_arg => undef,
    clearer  => '_close_io_write',
    coerce   => 1, 
    handles  => [qw(print printf)], 
    default  => sub { shift->script }
); 

1
