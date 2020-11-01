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
        _get    => 'get', 
    }, 
    trigger => sub ($self, $new, $old) { 
        # unload old mpi module 
        my ($old_mpi) = grep { $_ } map { /(impi|openmpi|mvapich2)/; $1 } $old->@*; 
        if ($old_mpi) {  
            my $unloader = "_unload_$old_mpi"; 

            $self->$unloader; 
        }

        # load new mpi module
        my ($new_mpi) = grep { $_ } map { /(impi|openmpi|mvapich2)/; $1 } $new->@*; 
        if ($new_mpi) {
            my $loader    = "_load_$new_mpi";  
            my $mpi_index = $self->_index(sub {/$new_mpi/}); 
            my $mpi_opt   = $self->_get($mpi_index+1); 

            # check for existence of hash option
            ref $mpi_opt eq 'HASH'
            ? $self->$loader($mpi_opt)
            : $self->$loader({})
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
    for my $module (@args) { 
        my $index = $self->_index(sub {/$module/});   
        
        ref $self->_get($index+1) eq 'HASH'
        ? $self->_delete($index, 2)
        : $self->_delete($index, 1)
    } 
    
    return $self
} 

sub switch ($self, $old, @news) { 
    $self->unload($old) 
         ->load  (@news)
} 

sub write_module ($self) {
    my @modules = $self->list; 

    if (@modules) { 
        $self->printf("module purge\n"); 

        for my $module ($self->list) {  
            next if ref $module eq 'HASH'; 

            $self->printf("module load %s\n", $module)        
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
