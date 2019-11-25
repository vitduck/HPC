package HPC::Sched::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use HPC::Types::Sched::Src qw(Src_Mkl Src_Mpi); 
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
    trigger => sub ($self, $new_module, $old_module) { 
        # for old MPI environment 
        $self->_unload_mpi_module($_) for $old_module->@*;

        # for new MPI environment
        $self->_load_mpi_module  ($_) for $new_module->@*; 
    }
); 

has 'mklvar' => (
    is        => 'rw', 
    isa       => Src_Mkl, 
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_mklvar',
    coerce    => 1 
); 

has 'mpivar'  => (
    is        => 'rw', 
    isa       => Src_Mpi, 
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

    if ($self->_has_mpi == 0) { 
        if    ( $module =~ /impi/     ) { $load_mpi = '_load_impi'     } 
        elsif ( $module =~ /openmpi/  ) { $load_mpi = '_load_openmpi'  }
        elsif ( $module =~ /mvapich2/ ) { $load_mpi = '_load_mvapich2' } 
    } 

    $self->$load_mpi($module) if $load_mpi;  
} 

sub _unload_mpi_module($self, $module) { 
    my $unload_mpi; 

    if ($self->_has_mpi == 0) { 
        if    ( $module =~ /impi/     ) { $unload_mpi = '_unload_impi'     } 
        elsif ( $module =~ /openmpi/  ) { $unload_mpi = '_unload_openmpi'  }
        elsif ( $module =~ /mvapich2/ ) { $unload_mpi = '_unload_mvapich2' } 
    } 
    
    $self->$unload_mpi if $unload_mpi
} 

sub write_module ($self) { 
    if ($self->_list_module != 0) {
        $self->printf("\n"); 
        $self->printf("module purge\n"); 

        for ($self->_list_module) { 
            $self->printf("module load %s\n", $_)
        }
    }

    $self->printf("%s\n", $self->get_mpivar) if $self->_has_mpivar; 
    $self->printf("%s\n", $self->get_mpivar) if $self->_has_mpivar; 

    return $self
} 

1
