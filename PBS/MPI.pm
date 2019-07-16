package HPC::PBS::MPI; 

use MooseX::Role::Parameterized; 
use signatures; 

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
        handles   => (
            $mpi eq 'impi'    ? [ qw(impi_debug) ] : 
            $mpi eq 'openmpi' ? [] : 
            []
        ), 
    ) 
}; 

1; 
