package HPC::Env::IMPI; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modify 'source'; 
use IO::String; 

sub source_impi { 
    my ( $self, $impi ) = @_; 

    my $mpihome = $self->_find_mpihome($impi); 

    source("$mpihome/bin64/mpivars.sh");  
   
    # manual load IMPI
    $self->_load_impi
}

sub unsource_impi { 
    my ($self, $impi) = @_;  

    $ENV{LD_LIBRARY_PATH} = 
        join ":", 
        grep !/linux\/mpi/, $self->list_ld_library_path;      
    
    # manual load IMPI
    $self->_unload_impi; 
}

sub _find_mpihome { 
    my ($self, $impi) = @_; 
    
    # corresponding impi module
    my $intel = $impi =~ s/impi/intel/r; 

    # find currently loaded gcc 
    my $gcc = $self->find_module(sub {/gcc/}); 
    $self->unload($gcc) if $gcc;  

    # load intel and impi module 
    $self->load($intel); 
    $self->load($impi);  

    my $io = IO::String->new(capture_stderr {system 'modulecmd', 'perl', 'show', $impi}); 

    my $mpihome; 
    for ($io->getlines) { 
        if (/MPIHOME/) { 
            $mpihome =  (split)[-1]; 
            last; 
        }
    }

    # now unload intel module 
    $self->unload($impi);     
    $self->unload($intel); 

    # reload gcc 
    $self->load($gcc) if $gcc;  

    return $mpihome; 
} 

1 
