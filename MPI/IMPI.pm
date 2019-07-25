package HPC::MPI::IMPI; 

use Moose; 
use MooseX::Types::Moose qw/Int/; 
use Env qw/I_MPI_DEBUG/; 

with 'HPC::MPI::Module'; 

has 'I_MPI_DEBUG' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { $I_MPI_DEBUG = shift->I_MPI_DEBUG }
);

sub reset_mpi_env { 
    undef $I_MPI_DEBUG
} 

sub mpirun { return 'mpirun' }

__PACKAGE__->meta->make_immutable;

1
