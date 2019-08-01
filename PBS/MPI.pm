package HPC::PBS::MPI; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str); 

use HPC::MPI::IMPI;  
use HPC::MPI::OPENMPI; 
use HPC::MPI::MVAPICH2; 
use HPC::MPI::Types qw(IMPI OPENMPI MVAPICH2); 

has '_mpi' => ( 
    is       => 'rw', 
    isa      =>  Str, 
    init_arg => undef,
    writer   => '_set_mpi', 
    clearer  => '_unset_mpi', 
); 

has 'impi' => (
    is       => 'rw', 
    isa      => IMPI, 
    coerce   => 1, 
    init_arg => undef, 
    writer   => '_load_impi',
    clearer  => '_unload_impi', 
    handles  => { 
          set_impi_env =>   'set_env', 
        unset_impi_env => 'unset_env', 
        reset_impi_env => 'reset_env', 
    }
); 

has 'openmpi' => (
    is       => 'rw', 
    isa      => OPENMPI, 
    coerce   => 1, 
    init_arg => undef, 
    writer   => '_load_openmpi',
    clearer  => '_unload_openmpi', 
    handles  => { 
          set_openmpi_env =>   'set_env', 
        unset_openmpi_env => 'unset_env', 
        reset_openmpi_env => 'reset_env', 
    }
); 

has 'mvapich2' => ( 
    is       => 'rw', 
    isa      => MVAPICH2, 
    coerce   => 1, 
    init_arg => undef, 
    writer   => '_load_mvapich2',
    clearer  => '_unload_mvapich2', 
    handles  => { 
          set_mvapich2_env =>   'set_env', 
        unset_mvapich2_env => 'unset_env', 
        reset_mvapich2_env => 'reset_env', 
    }
); 

sub _load_mpi {
    my ($self, $module) = @_; 
    
    # cray-impi module
    my $mpi = $1 if $module =~ /(impi|openmpi|mvapich2)/;

    # check for MPI conflict: 
    if ( $self->_mpi ) {  
        my $msg = sprintf("=> %s conficts with %s\n", $mpi, $self->_mpi); 
        die "$msg"; 
    } 

    # coercion module to MPI class
    my $load = "_load_$mpi"; 
    $self->$load($module); 
    $self->_set_mpi($mpi); 
}

sub _unload_mpi {
    my ($self, $module) = @_; 

    # cray-impi module
    my $mpi = $1 if $module =~ /(impi|openmpi|mvapich2)/;  

    # remove MPI using clearer
    if ( $mpi eq $self->_mpi ) { 
        my $unload = "_unload_$mpi"; 
        $self->$unload; 
        $self->_unset_mpi; 
    }
}

sub mpirun {
    my $self = shift; 
    my @opts = (); 
    
    my $mpi = $self->_mpi; 

    if ($mpi) { 
        # flat/mcdram/ddr4 mode
        push @opts, $self->numa if $self->numa;  
        push @opts, $self->$mpi->opt;  
        
        return join ' ', $self->$mpi->mpirun, @opts 
    }
}

1 
