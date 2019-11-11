package HPC::Debug::Data;  

use Moose::Role; 
use Data::Printer { 
    class => {     
        internals    => 1,  
        parents      => 0, 
        expand       => 'all', 
        show_methods => 'none' },
    scalar_quotes => '' };  
use feature qw(signatures); 
no warnings qw(experimental::signatures);

sub dump ($self) { 
    p $self; 

    return $self; 
} 

1 
