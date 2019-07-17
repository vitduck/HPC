package HPC::Env::Cmd; 

use Moose::Role; 

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

sub _load_module { 
    my ($self, $module) = @_; 

    Env::Modulecmd::load($module); 
} 

sub _unload_module { 
    my ($self, $module) = @_; 
    
    Env::Modulecmd::unload($module); 
}

1
