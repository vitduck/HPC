package HPC::Env::IMPI; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modify 'source'; 
use IO::String; 

sub source_impi { 
    my ( $self, $impi ) = @_; 

    my $gcc   = $self->find_module(sub {/gcc/}); 
    my $intel = $impi =~ s/impi/intel/r; 
    
    # unload pre-loaded gcc module 
    $self->unload($gcc) if $gcc;  
    
    # load intel and impi module 
    $self->load($intel); 
    $self->load($impi);  

    # find Intel MPI path 
    my $io = IO::String->new(capture_stderr {system 'modulecmd', 'perl', 'show', $impi}); 
    for ($io->getlines) { 
        if (/MPIHOME/) { 
            my $mpihome = (split)[-1];
            source("$mpihome/bin64/mpivars.sh");  
            last; 
        } 
    }
         
    # unload intel modules
    $self->unload($impi); 
    $self->unload($intel); 

    # load gcc again
    $self->load($gcc) if $gcc; 

   
    # manual load IMPI
    $self->_load_impi($impi); 
    $self->mpirun; 
}

sub unsource_impi { 
    my ($self, $impi) = @_;  

    $ENV{LD_LIBRARY_PATH} = 
        join ":", 
        grep !/linux\/mpi/, $self->list_ld_library_path;      
    
    # manual load IMPI
    $self->_unload_impi($impi); 
    $self->_reset_mpirun; 
}

1 
