package HPC::Env::Module; 

use Moose::Role; 
use Capture::Tiny 'capture_stderr';
use Env::Modulecmd; 

with 'HPC::Env::MKL'; 
with 'HPC::Env::IMPI'; 

has 'modules' => (   
    is       => 'rw',
    isa      => 'ArrayRef[Str]', 
    traits   => ['Array'], 
    init_arg => undef, 
    builder  => '_build_modules', 
    handles  => { 
        list_module    => 'elements', 
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

sub load { 
    my ($self, @modules) = @_; 

    for my $module (@modules) { 
        $self->_add_module ($module); 
        $self->_load_module($module); 
        if ( $module =~ /(impi|openmpi|mvapich2)/ ) {  
            my $method = "_load_$1"; 
            $self->$method($module); 
            $self->mpirun; 
        }
    }
}

sub unload { 
    my ($self, @modules) = @_; 

    for my $module (@modules) { 
        my $index = $self->_index_module(sub {/$module/}); 

        if ($index) { 
            $self->_delete_module($index); 
            $self->_unload_module($module); 
            $self->_unload_impi($module) if $module =~ /impi/; 
            if ( $module =~ /(impi|openmpi|mvapich2)/ ) {  
                my $method = "_unload_$1"; 
                $self->$method($module); 
                $self->_reset_mpirun; 
            }
        }
    }
}

sub switch { 
    my ($self, $old_module, $new_module) = @_; 

    $self->unload($old_module); 
    $self->load  ($new_module); 
}

sub initialize { 
    my $self = shift; 

    for my $module ($self->list_module) { 
        # do not remove opa module
        next if $module =~ /craype-network-opa/; 

        $self->unload($module); 
    }

    $self->_ld_library_path; 
} 

sub _build_modules { 
    return [ 
        grep !/\d+\)/, 
        grep !/Currently|Loaded|Modulefiles:/,
        split ' ',  
        capture_stderr { system 'modulecmd', 'perl', 'list' } 
    ]
}

sub _build_ld_library_path { 
    return [ split /:/, $ENV{LD_LIBRARY_PATH} ] 
}

sub _load_module { 
    my ($self, $module) = @_; 

    Env::Modulecmd::load($module); 
} 

sub _unload_module { 
    my ($self, $module) = @_; 
    
    Env::Modulecmd::unload($module); 
}

# rebuild cached ld_library_path
after [qw(load load_mkl load_impi unload unload_mkl unload_impi)] => sub { 
    my $self = shift; 

    $self->_clear_ld_library_path; 
    $self->_ld_library_path; 
}; 

1; 
