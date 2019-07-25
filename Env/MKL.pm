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

    my $version = (split /\//, $module)[1]; 

    for my $dir (qw/tbb compiler mkl/) { 
        my $index = $self->index_ld_library_path(sub {/intel\/$version\/.+?$dir/}); 
        $self->delete_ld_library_path($index);  
    }
}

sub _find_mklroot { 
    my ($self, $intel) = @_; 

    my $io = IO::String->new(capture_stderr {system 'modulecmd', 'perl', 'show', $intel}); 

    for ($io->getlines) { 
        return (split)[-1] if /MKLROOT/; 
    }
}

1 
