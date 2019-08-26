package HPC::MPI::Types::MPI;  

use IO::File; 
use MooseX::Types::Moose qw(Str Int); 
use MooseX::Types -declare => [qw(NPROCS HOSTFILE)]; 

# general mpirun options
subtype NPROCS,   as Str, where { /^\-np/       }; 
subtype HOSTFILE, as Str, where { /^\-hostfile/ }; 

coerce NPROCS,   from Int, via { join ' ', '-np', $_       }; 
coerce HOSTFILE, from Str, via { join ' ', '-hostfile', $_ }; 

1
