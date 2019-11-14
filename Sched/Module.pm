package HPC::Sched::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use HPC::Sched::Types::Src qw(SRC_MKL SRC_MPI); 
use feature 'signatures';  
no warnings 'experimental::signatures'; ;

# to be removed
# use Env::Modulecmd; 
# use Capture::Tiny 'capture_stderr'; 

with qw(
    HPC::Sched::MPI
    HPC::Sched::Env ); 

has 'module' => (
    is      => 'rw',
    isa     => ArrayRef[Str], 
    traits  => [qw(Array Chained)], 
    default => sub {[]}, 
    handles => { 
             _add_module => 'push', 
            _list_module => 'elements',
          _remove_module => 'delete', 
        _index_of_module => 'first_index', 
    }, 
    trigger => sub ($self, $new_module, $old_module) { 
        $self->_unload_mpi_module($_) for $old_module->@*;
        $self->_load_mpi_module  ($_) for $new_module->@*; 
    }
); 

has 'mklvar' => (
    is        => 'rw', 
    isa       => SRC_MKL, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_mklvar',
    coerce    => 1 
); 

has 'mpivar'  => (
    is        => 'rw', 
    isa       => SRC_MPI, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_mpivar', 
    coerce    => 1,  
    trigger   => sub ($self, $mpi_module, @) { 
        $self->_load_module($mpi_module)
    } 
); 

sub purge($self) { 
    $self->module([]); 

    return $self
} 

sub load ($self, @modules) { 
    my $load_mpi; 

    for my $module ( @modules ) { 
        my $index = $self->_index_of_module(sub {/$module/}) ; 

        if ($index == -1) { 
            $self->_add_module($module);  
            $self->_load_mpi_module($module); 
        } 
    }

    return $self; 
} 

sub unload ($self, @modules) { 

    for my $module ( @modules ) { 
        my $index = $self->_index_of_module(sub {/$module/}) ; 
        
        if ($index != -1) { 
            $self->_remove_module($index); 
            $self->_unload_mpi_module($module)
        }
    }

    return $self 
} 

# emulate 'module switch'
sub switch ($self, $old, $new) { 
    $self->unload($old)->load($new); 

    return $self
} 

sub _load_mpi_module($self, $module) { 
    my $load_mpi; 

    if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/ and $self->_has_mpi == 0) {
        $load_mpi = "_load_$1"; 
        $self->$load_mpi($module);  
    }
} 

sub _unload_mpi_module($self, $module) { 
    my $unload_mpi; 

    if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/) {
        $unload_mpi = "_unload_$1"; 
        $self->$unload_mpi 
    }
} 

sub _write_module ($self) { 
    if ($self->_list_module != 0) {
        $self->printf("module purge\n"); 

        for ($self->_list_module) { 
            $self->printf("module load %s\n", $_)
        }
    }

    $self->printf("%s\n", $self->get_mpivar) if $self->_has_mpivar; 
    $self->printf("%s\n", $self->get_mpivar) if $self->_has_mpivar; 
} 

# to be removed
# sub init ($self) {

    # $self->_unload_module(
        # reverse
        # grep !/\d+\)/,
        # grep !/Currently|Loaded|Modulefiles:/,
        # split(' ', capture_stderr { system 'modulecmd', 'perl', 'list' })
    # );

    # return $self; 
# }

# sub _load_module ($self, @modules) { 
    # Env::Modulecmd::load(@modules);
    
    # return $self
# }

# sub _unload_module ($self, @modules) { 
    # Env::Modulecmd::unload( @modules );

    # return $self; 
# }

1
