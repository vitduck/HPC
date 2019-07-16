package HPC::Env::IMPI; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modify 'source'; 
use IO::String; 

sub load_impi { 
    my ( $self, $impi ) = @_; 

    my $version = (split /\//, $impi)[1]; 
    my ($gcc) = grep /gcc/, $self->list_module; 
    
    # unload pre-loaded gcc module 
    # load intel and impi module 
    $self->unload($gcc) if $gcc;  
    $self->load("intel/$version"); 
    $self->load("$impi"); 
    
    my $io = IO::String->new(
        capture_stderr {system 'modulecmd', 'perl', 'show', $impi}
    ); 
    
    for ($io->getlines) { 
        if (/MPIHOME/) { 
            my $mpihome = (split)[-1];
            source("$mpihome/bin64/mpivars.sh");  
            
            # reverse 
            $self->unload("$impi"); 
            $self->unload("intel/$version"); 
            $self->load($gcc) if $gcc;  

            return
        } 
    }
}

sub unload_impi { 
    my $self = shift; 

    $ENV{LD_LIBRARY_PATH} = 
        join ":", 
        grep !/linux\/mpi/, $self->list_ld_library_path;      

}

1 
