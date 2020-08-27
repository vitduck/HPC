package HPC::Sched::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use Array::Diff; 
use HPC::Types::Sched::Module 'Module'; 
use feature 'signatures';  
no warnings 'experimental::signatures'; ;

has 'module' => (
    is      => 'rw',
    isa     => Module, 
    traits  => [qw(Array Chained)], 
    coerce  => 1, 
    default => sub {[]}, 
    handles => { 
             _add_module => 'push', 
            _list_module => 'elements',
          _remove_module => 'delete', 
        _index_of_module => 'first_index', 
    }, 
    trigger => sub ($self, $new, $old) { 
        my $diff = Array::Diff->diff($old, $new); 

        $self->_unload_mpi_module($_) for $diff->deleted->@*; 
        $self->_load_mpi_module($_)   for $diff->added->@*; 
    }
); 

sub purge($self) { 
    $self->unload($self->_list_module); 

    return $self
} 

sub load ($self, @modules) { 
    my $index; 

    for my $module ( @modules ) { 
        $index = 
            ref $module eq 'ARRAY'   
                ? $self->_index_of_module(sub {/$module->[0]/})
                : $self->_index_of_module(sub {/$module/     });  

        if ($index == -1) { 
            $self->_add_module(
                ref $module eq 'ARRAY'   
                    ? $module->[0] 
                    : $module );  
                
            $self->_load_mpi_module($module); 
        } 
    }

    return $self; 
} 

sub unload ($self, @modules) { 
    my $index; 

    for my $module ( @modules ) { 
        my $index = 
            ref $module eq 'ARRAY' 
                ? $self->_index_of_module(sub {/$module->[0]/}) 
                : $self->_index_of_module(sub {/$module/}     ); 
        
        if ($index != -1) { 
            $self->_remove_module(
                ref $module eq 'ARRAY'   
                    ? $module->[0] 
                    : $module );  

            $self->_unload_mpi_module($module); 
        }
    }

    return $self 
} 

# emulate 'module switch'
sub switch ($self, $old, $new) { 
    $self->unload($old)
         ->load($new); 

    return $self
} 

sub write_module ($self) { 
    if ($self->_list_module != 0) {
        $self->printf("\n"); 
        $self->printf("module purge\n"); 

        for my $module ($self->_list_module) { 
            ref $module eq 'ARRAY' 
                ? $self->printf("module load %s\n", $module->@*)
                : $self->printf("module load %s\n", $module    ); 
        }
    }

    return $self
} 

sub _load_mpi_module ($self, $module) { 
    my $mpi_module = ref $module eq 'ARRAY' ? $module->[0] : $module; 
    my $mpi_type   = $1 if $mpi_module =~ /(impi|openmpi|mvapich2)/; 

    if ($mpi_type) { 
        my $loader = "_load_$mpi_type"; 
        
        $self->$loader($module); 
    }
} 

sub _unload_mpi_module ($self, $module) { 
    my $mpi_module = ref $module eq 'ARRAY' ? $module->[0] : $module; 
    my $mpi_type   = $1 if $mpi_module =~ /(impi|openmpi|mvapich2)/; 

    if ($mpi_type) { 
        my $unloader = "_unload_$mpi_type"; 
        
        $self->$unloader 
    }
}

1
