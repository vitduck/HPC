package HPC::MPI::Module; 

use Moose::Role;  

requires 'mpirun'; 

sub set_opt { 
    my ($self, @opts) = @_; 

    while ( my ($attr, $value) = splice @opts, 0, 2) { 
        $self->$attr($value); 
    } 
} 

1 
