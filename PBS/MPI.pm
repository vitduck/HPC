package HPC::PBS::MPI; 

use Moose::Role; 
use HPC::MPI::IMPI; 
use HPC::MPI::OPENMPI; 
use HPC::MPI::MVAPICH2; 
use HPC::MPI::CRAYIMPI; 

for my $mpi (qw/impi openmpi mvapich2 crayimpi/) { 
    has "$mpi"  => (
        is        => 'rw',
        isa       => 'HPC::MPI::'.uc($mpi),
        init_arg  => undef,
        lazy      => 1,
        reader    => "_load_$mpi", 
        clearer   => "_unload_$mpi", 
        predicate => "has_$mpi",
        default   => sub { ('HPC::MPI::'.uc($mpi))->new },
        handles   => { 
            "set_$mpi"         => 'set_opt',  
            "reset_${mpi}_env" => 'reset_mpi_env', 
        }
    ); 
}

sub mpirun { 
    my $self = shift; 

    return  
        $self->has_impi     ? 'mpirun' : 
        $self->has_crayimpi ? 'mpirun' : 
        $self->has_openmpi  ? $self->openmpi->mpirun($self->omp) : 
        $self->has_mvapich2 ? $self->mvapich2->mpirun($self->select, $self->ncpus, $self->omp) :
        undef
} 

1 
