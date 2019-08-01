package HPC::MPI::Options; 

use IO::File; 
use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  

use MooseX::Types -declare => [qw(
    NPROCS HOSTFILE 
    OMP_IMPI OMP_OPENMPI OMP_MVAPICH2 
    ENV_IMPI ENV_OPENMPI ENV_MVAPICH2 )]; 

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

# hybrid mpi-openmpi
subtype OMP_IMPI,
    as Str, 
    where { $_ eq '' };  

coerce OMP_IMPI, 
    from Int, 
    via { '' }; 

subtype OMP_OPENMPI,
    as Str, 
    where { $_ eq '' or $_ =~/\-\-map\-by/ }; 

coerce OMP_OPENMPI, 
    from Int, 
    via { $_ == 1 ? '' : '--map-by NUMA:PE='.$_ }; 

subtype OMP_MVAPICH2,
    as Str, 
    where { $_ eq '' or $_ =~/^OMP/ }; 

coerce OMP_MVAPICH2, 
    from Int, 
    via { $_ == 1 ? '' : 'OMP_NUM_THREADS='.$_ }; 

# mpi environement variable  
subtype ENV_IMPI,
    as Str; 

coerce ENV_IMPI, 
    from HashRef, 
    via { 
        my $env = $_;  

        $env->%* 
        ? ( 
            join ' ', 
            map { ('-env', $_) }
            map { $_.'='.$env->{$_} } keys $env->%* ) 
        : ''
    }; 

subtype ENV_OPENMPI,
    as Str; 

coerce ENV_OPENMPI, 
    from HashRef, 
    via { 
        my $env = $_;  

        $env->%* 
        ? ( 
            join ' ', 
            map { ('-x', $_) }
            map { $_.'='.$env->{$_} } keys $env->%* ) 
        : ''
    }; 

subtype ENV_MVAPICH2,
    as Str; 

coerce ENV_MVAPICH2, 
    from HashRef, 
    via { 
        my $env = $_;  

        $env->%* 
        ? ( 
            join ' ', 
            map { $_.'='.$env->{$_} } keys $env->%* ) 
        : ''
    }; 

1
