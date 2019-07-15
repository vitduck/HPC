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
    my $class = "HPC::MPI::" . uc($mpi); 

    has $mpi => ( 
        is        => 'rw',
        isa       => $class,
        init_arg  => undef,
        lazy      => 1, 
        reader    => "_load_$mpi", 
        clearer   => "_unload_$mpi", 
        default   => sub ( $self ) { $class->new }
    ) 
}; 

1; 
