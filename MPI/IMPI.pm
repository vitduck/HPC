package HPC::MPI::IMPI; 

use Moose;  

with 'HPC::MPI::Version'; 

has 'I_MPI_DEBUG' => ( 
    is      => 'rw', 
    traits  => ['Bool'],
    isa     => 'Bool',
    default => 0, 
    handles => { impi_debug => 'set' } , 
    trigger => sub { $ENV{I_MPI_DEBUG} = 5 }
);

__PACKAGE__->meta->make_immutable;

1; 
