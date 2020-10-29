package HPC::Sched::Module; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef Str);
use HPC::Types::Sched::Module 'Module'; 

use namespace::autoclean; 
use experimental 'signatures';  

has module => (
    is       => 'rw',
    isa      => ArrayRef, 
    init_arg => undef,
    traits   => [qw(Array Chained)], 
    default  => sub {[]}, 
    handles  => { 
        list    => 'elements',
        load    => 'push',
        purge   => 'clear', 
        _delete => 'splice',
        _index  => 'first_index',
    }, 
    trigger => sub ($self, $new, $old) { 
        my @old_modules = $old->@*; 
        my @new_modules = $new->@*; 

        # unload old mpi module 
        my ($mpi_lib) = grep /impi|openmpi|mvapich2/, @old_modules; 
        if ($mpi_lib) {  
            $self->_unload_mpi($mpi_lib) 
        }

        # load new mpi module
        while (my ($mpi_lib, $mpi_ver) = splice @new_modules, 0, 2) {
            if ($mpi_lib =~ /impi|openmpi|mvapich2/) { 
                $self->_load_mpi($mpi_lib, $mpi_ver); 
            } 
        } 
    }
); 

around 'load' => sub ($load, $self, @args) {  
    $self->$load(@args); 
    
    return $self; 
}; 

around 'purge' => sub ($purge, $self, @) {  
    $self->$purge; 

    return $self; 
};  

sub unload ($self, @args) { 
    while (my ($module, $version) = splice @args, 0, 2) { 
        my $index = $self->_index(sub {/$module/});   
        $self->_delete($index, 2); 
    } 

    return $self
} 

sub switch ($self, $old, $old_ver, $new, $new_ver) { 
    $self->unload($old, $old_ver) 
         ->load  ($new, $new_ver)
} 

sub write_module ($self) {
    my @modules = $self->list; 

    if (@modules) { 
        $self->printf("module purge\n"); 

        while (my($module, $version) = splice @modules, 0, 2) { 
            my $module_string = 
                ref $version eq 'HASH' 
                ? join '/', $module, $version->{version} 
                : join '/', $module, $version; 
                
            $self->printf("module load %s\n", $module_string)        
        }

        $self->printf("\n"); 
    } 

    return $self
}

sub _load_mpi ($self, $mpi_lib, $mpi_ver) { 
    my $loader = "_load_$mpi_lib"; 

    $self->$loader($mpi_ver)
}

sub _unload_mpi ($self, $mpi_lib) { 
    my $unloader = "_unload_$mpi_lib"; 

    $self->$unloader; 
}

1
