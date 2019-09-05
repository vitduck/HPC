package HPC::PBS::Sys; 

use Moose::Role; 

use File::Path qw(make_path); 
use File::Copy qw(copy move);

sub mkdir { 
    my ($self, @dirs) = @_; 

    make_path($_) for @dirs; 
} 

sub chdir { 
    my ($self, $dir) = @_; 

    chdir($dir); 
} 

sub cp { 
    my ($self, $source, $destination) = @_; 

    copy($source => $destination);  
}

sub mv { 
    my ($self, $source, $destination) = @_; 

    move($source => $destination); 
} 

sub wait { 
    my ($self, $time) = @_; 

    sleep ($time)
} 

1
