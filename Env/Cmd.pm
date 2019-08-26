package HPC::Env::Cmd; 

use Moose::Role; 

sub load { 
    my ($self, @modules) = @_; 

    for my $module (@modules) { 
        my $index = $self->_index_module(sub {/$module/}); 

        if ($index == -1) { 
            $self->_add_module($module);  
            
            if ($module =~ /cray-impi|impi|openmpi|mvapich2/) {  
                $self->load_mpi($module); 
            }
        }
    }
}

sub unload { 
    my ($self, @modules) = @_; 

    for my $module (@modules) {
        my $index = $self->_index_module(sub {/$module/}); 

        if ($index) { 
            # remove module from 
            $self->_remove_module($index); 

            # remove mpi attributes
            if ($module =~ /impi|openmpi|mvapich2/) {
                if ($self->has_mpi) { 
                    $self->unload_mpi;  
                }
            }

            $self->_unload_module($module); 
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
    
    my @tobe_unloaded = (); 

    # unload all modules except opa
    # mpi module must be removed before compiler module
    for my $module ($self->list_module) { 
        if ($module =~ /craype-network-opa/) {  
            next; 

        } elsif ($module =~ /impi|openmpi|mvapich2/) { 
            unshift @tobe_unloaded, $module
        
        } else { 
            push @tobe_unloaded, $module
        }
    }

    $self->unload(@tobe_unloaded); 
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
