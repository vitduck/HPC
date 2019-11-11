package HPC::PBS::Sys; 

use Moose::Role; 
use File::Path qw(make_path); 
use File::Copy qw(copy move);

use feature 'signatures';  
no warnings 'experimental::signatures'; 

sub mkdir ($self, @dirs) { 
    make_path($_) for @dirs; 

    return $self
} 

sub chdir ($self, $dir) { 
    chdir($dir); 
    
    return $self
} 

sub cp ($self, $source, $destination) { 
    copy($source => $destination);  
    
    return $self
}

sub mv ($self, $source, $destination) {
    move($source => $destination); 
    
    return $self
} 

sub wait ($self, $time) {
    sleep ($time); 
    
    return $self
} 

1
