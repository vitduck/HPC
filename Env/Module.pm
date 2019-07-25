package HPC::Env::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw/ArrayRef Str/;
use Capture::Tiny 'capture_stderr';
use Env::Modulecmd; 

with 'HPC::Env::Cmd', 
     'HPC::Env::Path', 
     'HPC::Env::Preset', 
     'HPC::Env::IMPI',
     'HPC::Env::MKL'; 

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

sub _build_modules { 
    return [ 
        grep !/\d+\)/, 
        grep !/Currently|Loaded|Modulefiles:/,
        split ' ',  
        capture_stderr {system 'modulecmd', 'perl', 'list'}
    ]
}

1
