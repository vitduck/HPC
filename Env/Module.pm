package HPC::Env::Module; 

use Capture::Tiny 'capture_stderr';
use Env::Modulecmd; 
use Moose::Role; 
use MooseX::Types::Moose qw/ArrayRef Str/;

use HPC::Env::Types qw/SRC_MKL SRC_IMPI/; 

with 'HPC::Env::Cmd', 
     'HPC::Env::Preset'; 

has 'modules' => ( 
    is       => 'rw',
    isa      => ArrayRef[Str], 
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

has 'source_mkl' => ( 
    is       => 'rw', 
    isa      => SRC_MKL, 
    init_arg => undef, 
    coerce   => 1, 
    clearer  => '_unsource_mkl'
); 

has 'source_impi' => ( 
    is       => 'rw', 
    isa      => SRC_IMPI, 
    init_arg => undef, 
    coerce   => 1, 
    clearer  => '_unsource_impi'
); 

sub _build_modules { 
    return [ 
        grep !/\d+\)/, 
        grep !/Currently|Loaded|Modulefiles:/,
        split ' ',  
        capture_stderr {system 'modulecmd', 'perl', 'list'}
    ]
}

1
