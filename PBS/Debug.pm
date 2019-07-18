package HPC::PBS::Debug; 

use Moose::Role; 

use Data::Printer { 
    class => {     
        internals    => 1,  
        parents      => 0, 
        expand       => 'all', 
        show_methods => 'none'
    },
    scalar_quotes => '',
};  

sub dump { 
    my $self = shift; 

    p $self; 
} 

1 
