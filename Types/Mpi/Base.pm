package HPC::Types::Mpi::Base;

use IO::File;
use MooseX::Types::Moose qw(Str Int);
use MooseX::Types -declare => [qw(Nprocs Hostfile)];

# general mpirun options
subtype Nprocs,   as Str, where { /^\-np/       };
subtype Hostfile, as Str, where { /^\-hostfile/ }; 

coerce Nprocs,   from Int, via { join ' ', '-np', $_       };
coerce Hostfile, from Str, via { join ' ', '-hostfile', $_ };

1
