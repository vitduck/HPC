package HPC::MPI::OPENMPI; 

use Moose; 

with 'HPC::MPI::Version'; 

has 'mpirun' => ( 
    is       => 'ro', 
    isa      => 'Str', 
    init_arg => undef,
    lazy     => 1, 
    builder  => '_build_mpirun',  
    clearer  => '_clear_mpirun', 
); 

has 'affinity' => ( 
    is       => 'rw', 
    isa      => 'Str', 
    init_arg => undef, 
    default  => 1
); 

# sub _build_mpiexe { 
    # my $affinity = shift->affinity; 

    # return 
        # $ affinity == 1 
        # ? 'mpirun' 
        # : "mpirun --map-by NUMA:PE=$affinity"
# } 

__PACKAGE__->meta->make_immutable;

1
