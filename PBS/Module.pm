package HPC::PBS::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use HPC::PBS::Types::Src qw(SRC_MKL SRC_MPI); 
# use Env::Modulecmd; 
# use Capture::Tiny 'capture_stderr'; 

use feature 'signatures';  
no warnings 'experimental::signatures'; ;

with qw(HPC::PBS::Env HPC::PBS::MPI); 

has 'module' => (
    is        => 'rw',
    isa       => ArrayRef[Str], 
    traits    => ['Array', 'Chained'], 
    predicate => '_has_module',
    lazy      => 1,
    default   => sub {[]}, 
    handles   => { 
        _list_module     => 'elements', 
        _get_module      => 'get',
        _push_module     => 'push', 
        _unshift_module  => 'unshift', 
        _index_of_module => 'first_index', 
        _delete_module   => 'delete' 
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
    coerce    => 1 
); 

before 'module' => sub ($self, $arg) { 
    $self->purge 
};  

after 'module' => sub ($self, $arg) { 
    my $load_mpi; 

    # load mpi if it is required 
    for my $module ($arg->@*) { 
        if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/) {  
            $load_mpi = "_load_".$1; 
            $self->$load_mpi($module);  
        }
    }
};  

sub purge ($self) { 
    my ($mpi, $unload_mpi); 
    
    # unload module 
    $self->unload($self->_list_module); 

    # current MPI lib 
    if ($self->_has_mpi) { 
        $mpi        = $self->_get_mpi; 
        $unload_mpi = "_unload_$mpi"; 

        # reset MPI 
        $self->$unload_mpi; 
    }
   
    return $self; 
} 

sub load ($self, @modules) { 
    $self->_load_module($_) for @modules; 

    return $self; 
} 

sub unload ($self, @modules) { 
    $self->_unload_module($_) for @modules; 

    return $self; 
}

# emulate 'module switch'
sub switch ($self, $old, $new) { 
    $self->unload($old); 
    $self->load($new); 

    return $self
} 


# private 
sub _load_module ($self, $module) { 
    my ($index, $load_mpi);  
    
    $index = $self->_index_of_module(sub {/$module/}) ; 

    if ($index == -1) { 
        $self->_push_module($module);  

        # mpi 
        if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/ and $self->_has_mpi == 0) {
            $load_mpi = "_load_$1"; 
            $self->$load_mpi($module);  
        }
    } 
}

sub _unload_module ($self, $module) { 
    my ($index, $unload_mpi); 

    $index = $self->_index_of_module(sub {/$module/}) ; 
        
    if ($index != -1) { 
        $self->_delete_module($index); 

        # mpi
        if ($module =~ /^(?:cray\-)?(impi|openmpi|mvapich2)/) {
            $unload_mpi = "_unload_$1"; 
            $self->$unload_mpi 
        }
    }
} 

sub _write_pbs_module ($self) { 
    $self->print("\n"); 

    $self->_write_module; 
    $self->_write_mpivar; 
    $self->_write_mklvar
} 

sub _write_module ($self) { 
    if ($self->_list_module != 0) { 
        $self->printf("module purge\n"); 

        for ($self->_list_module) { 
            $self->printf("module load %s\n", $_)
        }
    }
} 

sub _write_mklvar ($self) { 
    $self->printf("%s\n", $self->get_mpivar) if $self->_has_mpivar; 
} 

sub _write_mpivar ($self) {  
    $self->printf("%s\n", $self->get_mpivar) if  $self->_has_mpivar; 
}

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
