package HPC::PBS::Chained; 

use Moose::Role; 

use feature 'signatures';  
no warnings 'experimental::signatures'; 

# chained delegation methods
around [qw(print printf close)] => sub ($delegation, $self, @args) { 
    $self->$delegation(@args); 

    return $self 
}; 

1
