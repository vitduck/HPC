package HPC::Env::Module; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modulecmd; 

with 'HPC::Env::MKL', 
     'HPC::Env::IMPI',
     'HPC::Env::Cmd', 
     'HPC::Env::Preset'; 

has 'modules' => (   
    is       => 'rw',
    isa      => 'ArrayRef[Str]', 
    traits   => ['Array'], 
    builder  => '_build_modules', 
    handles  => { 
        list_module    => 'elements', 
        find_module    => 'first',
        _add_module    => 'push', 
        _index_module  => 'first_index', 
        _delete_module => 'delete'
    }
); 

has '_ld_library_path' => ( 
    is       => 'rw',
    isa      => 'ArrayRef[Str]', 
    traits   => ['Array'], 
    init_arg => undef, 
    lazy     => 1, 
    clearer  => '_clear_ld_library_path', 
    builder  => '_build_ld_library_path',
    handles  => { 
        list_ld_library_path => 'elements'
    } 
); 

sub _build_modules { 
    return [ 
        grep !/\d+\)/, 
        grep !/Currently|Loaded|Modulefiles:/,
        split ' ',  
        capture_stderr {system 'modulecmd', 'perl', 'list'}
    ]
}

sub _build_ld_library_path { 
    return [split /:/, $ENV{LD_LIBRARY_PATH}] 
}

# rebuild cached ld_library_path
after [qw(load unload source_mkl unsource_mkl source_impi unsource_impi)] => sub { 
    my $self = shift; 

    $self->_clear_ld_library_path; 
    $self->_ld_library_path; 
}; 

1
