package HPC::Types::Mpi::Base;

use MooseX::Types::Moose qw(Str Int);
use MooseX::Types -declare => [qw(Nprocs Hostfile)];

use IO::File;

# general mpirun options
subtype Nprocs,   
    as Str, 
    where { /^\-np/ };
coerce Nprocs,   
    from Str, 
    via { join ' ', '-np', $_ };

subtype Hostfile, 
    as Str, 
    where { /^\-hostfile/ }; 
coerce Hostfile, 
    from Str, 
    via { join ' ', '-hostfile', $_ };

1
