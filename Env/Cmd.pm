package HPC::Env::Cmd; 

use Moose::Role; 

sub load { 
    my ($self, @modules) = @_; 

    for my $module (@modules) { 
        $self->_add_module($module); 
        $self->_load_mpi($module) if $module =~ /^(cray-impi|impi|openmpi|mvapich2)/; 
    }
}

sub unload { 
    my ($self, @modules) = @_; 

    for my $module (@modules) { 
        my $index = $self->_index_module(sub {/$module/}); 

        if ($index) { 
            $self->_delete_module($index); 
            $self->_unload_mpi if $module =~ /^(cray-impi|impi|openmpi|mvapich2)/; 
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

    # unload all modules except opa
    for my $module ($self->list_module) { 
        next if $module =~ /craype-network-opa/; 

        $self->unload($module); 
    }

    # cache LD_LIBRARY_PATH
    # $self->_ld_library_path; 
} 

# emulate 'module load'
sub _load_module { 
    my ($self, $module) = @_; 

    Env::Modulecmd::load($module); 
} 

# emulate 'module unload'
sub _unload_module { 
    my ($self, $module) = @_; 
    
    Env::Modulecmd::unload($module); 
}

1
