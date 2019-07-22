package HPC::MPI::IMPI; 

use Moose; 
use MooseX::Types::Moose qw/Int/; 

with 'HPC::MPI::Module'; 

has 'mpi_debug' => ( 
    is      => 'rw', 
    isa     => Int,
    default => 0, 
    trigger => sub { $ENV{I_MPI_DEBUG} = shift->mpi_debug }
);

sub mpirun { return 'mpirun' }

__PACKAGE__->meta->make_immutable;

1
