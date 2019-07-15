package HPC::MPI::IMPI; 

use Moose;  

with 'HPC::MPI::Version'; 

has 'mpirun' => ( 
    is       => 'ro', 
    isa      => 'Str', 
    init_arg => undef,
    default  => 'mpirun', 
); 

has 'I_MPI_DEBUG' => ( 
    is      => 'rw', 
    traits  => ['Bool'],
    isa     => 'Bool',
    default => 0, 
    handles => { enable_debug => 'set' }, 
    trigger => sub { $ENV{I_MPI_DEBUG} = 5 }
);

__PACKAGE__->meta->make_immutable;

1; 
