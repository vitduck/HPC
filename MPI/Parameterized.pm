package HPC::MPI::Parameterized; 

use MooseX::Role::Parameterized; 
use signatures; 

use HPC::MPI::IMPI; 
use HPC::MPI::OPENMPI; 
use HPC::MPI::MVAPICH2; 

parameter 'mpi' => ( 
    isa      => 'Str',  
    required => 1, 
);

role { 
    my $mpi   = shift->mpi; 
    my $type  = uc($mpi); 

    has $mpi => ( 
        is        => 'rw',
        isa       => $type,
        init_arg  => undef,
        predicate => "has_$mpi", 
        writer    => "_load_$mpi", 
        clearer   => "_unload_$mpi", 
        coerce    => 1,
    ) 
}; 

1; 
