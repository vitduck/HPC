package HPC::Env::MKL; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modify 'source'; 
use IO::String; 

sub load_mkl { 
    my ( $self, $intel) = @_; 

    my $io = IO::String->new(
        capture_stderr {system 'modulecmd', 'perl', 'show', $intel}
    ); 

    for ($io->getlines) { 
        if (/MKLROOT/) { 
            my $mklroot = (split)[-1];
            source("$mklroot/bin/mklvars.sh", 'intel64'); 
            return
        } 
    }
}

sub unload_mkl { 
    my $self = shift; 

    $ENV{LD_LIBRARY_PATH} = 
        join ":", 
        grep !/linux\/(tbb|compiler|mkl)/, $self->list_ld_library_path;      
}

1 
