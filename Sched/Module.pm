package HPC::Sched::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use HPC::Types::Sched::Src qw(Src_Mkl Src_Mpi); 
use HPC::Types::Sched::Module 'Module'; 
use Array::Diff; 
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

        for ($self->_list_module) { 
            $self->printf("module load %s\n", $_)
        }
    }

    return $self
} 

sub _load_mpi_module ($self, $module) { 
    if    ( $module =~ /impi/     ) { $self->_load_impi($module)     }
    elsif ( $module =~ /openmpi/  ) { $self->_load_openmpi($module)  }
    elsif ( $module =~ /mvapich2/ ) { $self->_load_mvapich2($module) } 
} 

sub _unload_mpi_module ($self, $module) { 
    if    ( $module =~ /impi/     ) { $self->_unload_impi     }
    elsif ( $module =~ /openmpi/  ) { $self->_unload_openmpi  } 
    elsif ( $module =~ /mvapich2/ ) { $self->_unload_mvapich2 }
} 

1
