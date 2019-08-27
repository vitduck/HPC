package HPC::Env::Cmd; 

use Moose::Role; 

sub load { 
    my ($self, @modules) = @_; 

    for my $module (@modules) { 
        # check if module is loaded 
        my $index = $self->_index_module(sub {/$module/}); 

        # module is not loaded
        if ($index == -1) { 
            # mpi module must be loaded last
            if ($module =~ /impi|openmpi|mvapich2/) {  
                $self->_push_module($module); 
                $self->load_mpi($module); 
            # otherl module
            } else { 
                $self->_unshift_module($module); 
            }
        } 
    }
}

sub unload { 
    my ($self, @modules) = @_; 

    my @to_be_unloaded = (); 

    for my $module (@modules) {
        # check if module is alread loaded
        my $index = $self->_index_module(sub {/$module/}); 
        
        # module is loaded
        if ($index != -1 ) { 
            # remove module from 'modules' attributes
            $self->_remove_module($index); 

            # mpi module must be unloaded first
            if ($module =~ /impi|openmpi|mvapich2/) {  
                # matching between loaded mpi and to-be-unloaded mpi 
                if ( $self->has_mpi and $self->mpi->module eq $module) { 
                    $self->unload_mpi;  
                }

                unshift @to_be_unloaded, $module
            # normal module 
            } else { 
                push @to_be_unloaded, $module
            }
        }
    }
    
    # unloaded module via Env::Modulecmd 
    for my $module (@to_be_unloaded) { 
        $self->_unload_module($module); 
    } 
}

sub switch { 
    my ($self, $old_module, $new_module) = @_; 

    $self->unload($old_module); 
    $self->load  ($new_module); 
}

sub initialize { 
    my $self = shift; 
    
    $self->unload($self->list_module); 
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
