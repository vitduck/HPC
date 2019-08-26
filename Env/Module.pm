package HPC::Env::Module; 

use Capture::Tiny 'capture_stderr';
use Env::Modulecmd; 
use Moose::Role; 
use MooseX::Types::Moose qw/ArrayRef Str/;

use HPC::Env::Types qw/SRC_MKL SRC_MPI/; 

with 'HPC::Env::Cmd', 
     'HPC::Env::Preset'; 

has 'modules' => (
    is       => 'rw',
    isa      => ArrayRef[Str], 
    traits   => ['Array'], 
    lazy     => 1,
    builder  => '_build_modules', 
    handles  => { 
        list_module    => 'elements', 
        find_module    => 'first',
        _add_module    => 'push', 
        _index_module  => 'first_index', 
        _remove_module => 'delete'
    }
); 

has 'mklvar' => (
    is       => 'rw', 
    isa      => SRC_MKL, 
    init_arg => undef, 
    coerce   => 1, 
    writer   => 'source_mkl',
); 

has 'mpivar' => (
    is       => 'rw', 
    isa      => SRC_MPI, 
    init_arg => undef, 
    coerce   => 1, 
    writer   => 'source_mpi',
    clearer  => 'unsource_mpi'
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
