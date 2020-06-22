package HPC::Debug::Dump; 

use Moose::Role; 

use Data::Printer { 
    class => {     
        internals    => 1,  
        parents      => 0, 
        expand       => 1, 
        show_methods => 'none' 
    },
    scalar_quotes => '' 
};  

use feature qw(signatures); 
no warnings qw(experimental::signatures);

sub dump ($self, $level=1) { 
    p ($self, class => { expand => $level }); 

    return $self
} 

1 
