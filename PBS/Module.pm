package HPC::PBS::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);

use Env::Modulecmd; 
use Capture::Tiny qw(capture_stderr);

use HPC::PBS::Types::Src qw(SRC_MKL SRC_MPI); 

with qw(
    HPC::PBS::Preset
    HPC::PBS::Path
    HPC::PBS::MPI
); 

has 'modules' => (
    is       => 'rw',
    isa      => ArrayRef[Str], 
    traits   => ['Array'], 
    lazy     => 1,
    default  => sub { [] }, 
    handles  => { 
        _list_module     => 'elements', 
        _get_module      => 'get',
        _push_module     => 'push', 
        _unshift_module  => 'unshift', 
        _index_of_module => 'first_index', 
        _delete_module   => 'delete' 
     },  
); 

has 'mklvar' => (
    is        => 'rw', 
    isa       => SRC_MKL, 
    init_arg  => undef, 
    coerce    => 1, 
    predicate => '_has_mklvar',
    writer    => 'src_mkl',
    clearer   => 'unsrc_mkl',
); 

has 'mpivar'  => (
    is        => 'rw', 
    isa       => SRC_MPI, 
    init_arg  => undef, 
    coerce    => 1, 
    predicate => '_has_mpivar', 
    writer    => 'src_mpi',
    clearer   => 'unsrc_mpi'
); 

# emulate 'module load'
sub load { 
    my $self = shift; 

    for my $module ( @_ ) { 
        my $index = $self->_index_of_module(sub {/$module/}) ; 
        
        if ($index == -1) { 
            $self->_push_module($module);  

            # mpi hook 
            if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/ and $self->has_mpi == 0) {
                my $mpi_loader = "_load_" . $1; 
                $self->$mpi_loader($module);  
            }
        }
    } 
}

# emulate 'module unload' 
sub unload { 
    my $self = shift; 

    for my $module ( @_ ) { 
        my $index = $self->_index_of_module(sub {/$module/}) ; 
        
        if ($index !=-1) { 
            $self->_delete_module($index); 

            # mpi hook 
            if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/) {
                my $mpi_unloader = "_unload_" . $1; 
                $self->$mpi_unloader; 
            }
        }
    } 
} 

sub init {
    my $self = shift;

    # module needs to be unloaded in reverse order due to dependency
    $self->_unload_module(
        reverse
        grep !/craype-network-opa/,
        grep !/\d+\)/,
        grep !/Currently|Loaded|Modulefiles:/,
        split(' ', capture_stderr { system 'modulecmd', 'perl', 'list' })
    );
}

# emulate 'module switch'
sub switch { 
    my ($self, $old_module, $new_module) = @_; 

    $self->unload($old_module); 
    $self->load  ($new_module); 
}

# emulate 'module load'
sub _load_module {
    my ($self, @modules) = @_;

    Env::Modulecmd::load( @modules );
}

# emulate 'module unload'
sub _unload_module {
    my ($self, @modules) = @_;

    Env::Modulecmd::unload( @modules );
}

sub _write_pbs_module { 
    my $self = shift; 

    $self->printf("module load %s\n", $_) for $self->_list_module;
    $self->printf("%s\n", $self->mklvar)  if  $self->_has_mklvar; 
    $self->printf("%s\n", $self->mpivar)  if  $self->_has_mpivar; 
    $self->print("\n"); 
} 

1
