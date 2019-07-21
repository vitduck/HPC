package HPC::PBS::MPI; 

use Moose::Role; 

with 'HPC::PBS::Types'; 

has 'mpi' => (
    is        => 'rw',
    isa       => 'HPC::PBS::Types::MPI', 
    coerce    => 1,
    init_arg  => undef,
    writer    => '_load_mpi',
    clearer   => '_unload_mpi',
    predicate => 'has_mpi',
); 

has 'mpirun' => (
    is       => 'rw',
    isa      => 'Str',
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_mpirun',
    clearer  => '_reset_mpirun',
);

after '_unload_mpi'   => sub { $_[0]->_reset_mpirun };  
after '_reset_mpirun' => sub { $_[0]->_reset_cmd    };  

sub _build_mpirun { 
    my $self = shift; 

    return  
        $self->has_mpi eq 'openmpi'  ? $self->mpi->mpirun($self->omp) : 
        $self->has_mpi eq 'mvapich2' ? $self->mpi->mpirun($self->select, $self->ncpus, $self->omp) :
        'mpirun'; 
} 

1 
