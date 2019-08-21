package HPC::MPI::Options; 

use IO::File; 
use MooseX::Types::Moose qw(Str Int); 
use MooseX::Types -declare => [qw(NPROCS HOSTFILE)]; 

# general mpirun options
subtype NPROCS, 
    as Str, 
    where { /^\-np/ }; 

coerce NPROCS,
    from Int, 
    via { join ' ', '-np', $_ }; 

subtype HOSTFILE,
    as Str, 
    where { /^\-hostfile/ }; 

coerce HOSTFILE,
    from Str, 
    via { join ' ', '-hostfile', $_  }; 

1
