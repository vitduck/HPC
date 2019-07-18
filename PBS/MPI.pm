package HPC::PBS::MPI; 

use Moose::Role; 
use Moose::Util::TypeConstraints; 
use feature 'switch'; 
no warnings "experimental::smartmatch";

use HPC::MPI::Lib; 

subtype 'HPC::PBS::Types::MPI' 
    => as 'Object'
    => where { $_->isa("HPC::MPI::Lib") }; 

coerce 'HPC::PBS::Types::MPI' 
    => from 'Str', 
    => via { 
        my ($mpi, $version) = split /\//, $_; 

        # for cray-impi/*
        $mpi  =~ s/-//; 
        
        my $role = join '::', 'HPC', 'MPI', uc($mpi);  
        HPC::MPI::Lib
            ->with_traits($role)
            ->new(module => $mpi, version => $version)
    }; 


has 'mpi' => (
    is        => 'rw',
    isa       => 'HPC::PBS::Types::MPI', 
    init_arg  => undef,
    writer    => '_load_mpi',
    clearer   => '_unload_mpi',
    predicate => 'has_mpi',
    lazy      => 1,
    coerce    => 1,
    default   => sub { HPC::MPI::Lib->new }, 
); 

has 'mpirun' => (
    is       => 'rw',
    isa      => 'Str',
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_mpirun',
    clearer  => '_reset_mpirun',
);

after '_unload_mpi' => sub { 
    my $self = shift; 

    $self->_reset_mpirun; 
    $self->_reset_cmd; 

}; 

sub _build_mpirun { 
    my $self = shift; 

    my $mpirun = ''; 

    if ($self->has_mpi) { 
        given ($self->mpi->module) { 
            when ('openmpi' ) {$mpirun = $self->mpi->mpirun($self->ompthreads)}
            when ('mvapich2') {$mpirun = $self->mvapich2->mpirun($self->select, $self->ncpus, $self->ompthreads)}
            default           {$mpirun = 'mpirun'} 
        }
    }

    return $mpirun; 
} 

1 
