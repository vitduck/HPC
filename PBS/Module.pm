package HPC::PBS::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use Capture::Tiny   qw(capture_stderr);
use Env::Modulecmd; 

use HPC::Env::Types qw(SRC_MKL SRC_MPI); 

with qw(HPC::Env::Cmd HPC::Env::Preset); 

has 'modules' => (
    is       => 'rw',
    isa      => ArrayRef[Str], 
    traits   => ['Array'], 
    lazy     => 1,

    default  => sub { 
        return [ 
            grep !/craype-network-opa/,
            grep !/\d+\)/, 
            grep !/Currently|Loaded|Modulefiles:/,
            split(' ', capture_stderr { system 'modulecmd', 'perl', 'list' }) 
        ]
    },  

    handles  => { 
            list_module => 'elements', 
           _push_module => 'push', 
        _unshift_module => 'unshift', 
          _index_module => 'first_index', 
         _remove_module => 'delete' 
     },  
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

sub _write_pbs_module { 
    my $self = shift; 

    $self->printf("module load %s\n", $_) for $self->list_module;
    $self->printf("%s\n", $self->mpivar ) if  $self->mpivar; 
    $self->printf("%s\n", $self->mklvar ) if  $self->mklvar; 
    $self->printf("\n"); 
} 

1
