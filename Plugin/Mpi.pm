package HPC::Plugin::Mpi; 

use Moose::Role; 
use HPC::Mpi::Impi;
use HPC::Mpi::Openmpi;
use HPC::Mpi::Mvapich2;
use HPC::Types::Sched::Mpi qw(Impi Openmpi Mvapich2); 
use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'impi' => (
    is        => 'rw', 
    isa       => Impi, 
    init_arg  => undef, 
    predicate => '_has_impi', 
    writer    => '_load_impi',
    clearer   => '_unload_impi', 
    coerce    => 1, 
 #    trigger   => sub ($self, @) { 
        # $self->_add_plugin('impi'); 
    # } 
); 

has 'openmpi' => (
    is        => 'rw', 
    isa       => Openmpi, 
    init_arg  => undef, 
    predicate => '_has_openmpi', 
    writer    => '_load_openmpi',
    clearer   => '_unload_openmpi', 
    coerce    => 1, 
    # trigger   => sub ($self, @) { 
        # $self->_add_plugin('openmpi'); 
    # } 
); 

has 'mvapich2' => (
    is        => 'rw', 
    isa       => Mvapich2, 
    init_arg  => undef, 
    predicate => '_has_mvapich2',
    writer    => '_load_mvapich2',
    clearer   => '_unload_mvapich2', 
    coerce    => 1, 
   #  trigger   => sub ($self, @) { 
        # $self->_add_plugin('mvapich2')
    # } 
); 

sub _has_mpi ($self) {
    for my $mpi (qw(impi openmpi mvapich2)) {
        my $has = "_has_$mpi";

        return 1 if $self->$has;
    }
}

sub _get_mpi ($self) {
    for my $mpi (qw(impi openmpi mvapich2)) {
        my $has = "_has_$mpi";

        return $mpi if $self->$has;
    }
}

sub mpirun ($self) {
    my $mpi  = $self->_get_mpi;

    return $self->$mpi->cmd
}

1
