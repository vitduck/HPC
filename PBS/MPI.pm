package HPC::PBS::MPI; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str); 

use HPC::MPI::IMPI::Module;  
use HPC::MPI::OPENMPI::Module; 
use HPC::MPI::MVAPICH2::Module; 
use HPC::MPI::Types qw(MPI); 

has 'mpi' => (
    is       => 'rw', 
    isa       => MPI, 
    coerce    => 1, 
    init_arg  => undef, 
    writer    => '_load_mpi',
    predicate => 'has_mpi', 
    clearer   => '_unload_mpi', 
    trigger   => sub { 
        my $self = shift; 

        $self->mpi->set_nprocs($self->select*$self->mpiprocs);

        if ($self->has_omp) {
            $self->mpi->set_omp($self->omp)
        }
    }
); 

sub mpirun {
    my $self = shift; 
    my @opts = (); 
    
    # flat/mcdram/ddr4 mode
    push @opts, $self->numa if $self->numa;  
    push @opts, $self->mpi->opt;  

    return join ' ', $self->mpi->mpirun, @opts 
}

1 
