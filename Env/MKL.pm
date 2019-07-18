package HPC::Env::MKL; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modify 'source'; 
use IO::String; 

sub source_mkl { 
    my ( $self, $intel) = @_; 
    
    my $mklroot = $self->_find_mklroot($intel); 

    source("$mklroot/bin/mklvars.sh", 'intel64'); 
}

sub unsource_mkl { 
    my ($self,$module) = @_; 

    $ENV{LD_LIBRARY_PATH} = 
        join ":", 
        grep !/linux\/(tbb|compiler|mkl)/, 
        $self->list_ld_library_path;      
}

sub _find_mklroot { 
    my ($self, $intel) = @_; 

    my $io = IO::String->new(capture_stderr {system 'modulecmd', 'perl', 'show', $intel}); 

    for ($io->getlines) { 
        return (split)[-1] if /MKLROOT/; 
    }
}

1 
