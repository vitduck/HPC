package HPC::MPI::Module; 

use Moose::Role;  

requires 'mpirun';  

sub set_opt { 
    my ($self, @opts) = @_; 

    while ( my ($attr, $value) = splice @opts, 0, 2) { 
        #convert to uppercase 
        $attr = uc($attr); 

        $self->$attr($value); 
    } 
} 

1 
