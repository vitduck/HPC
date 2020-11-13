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
            $self->_unload_mpi($old_mpi)
        }

        # load new mpi module
        my ($new_mpi) = grep { $_ } map { /(impi|openmpi|mvapich2)/; $1 } $new->@*; 
        if ($new_mpi) {
            my $index = $self->_index(sub {/$new_mpi/}); 
            my $opt   = $self->_get($index+1); 

            $self->_load_mpi($new_mpi, $opt)

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

sub _load_mpi ($self, $mpi, $opt) { 
    # check for existence of hash option
    ref $opt eq 'HASH'
        ? $self->$mpi($opt)
        : $self->$mpi({})

}

sub _unload_mpi ($self, $mpi) { 
    my $unload = "_unset_$mpi"; 

    $self->$unload
}

1
