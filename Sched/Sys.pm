package HPC::Sched::Sys; 

use Moose::Role; 
use File::Copy ();  
use File::Path qw(make_path); 
use File::Glob ':bsd_glob';  

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

sub copy ($self, $source, $destination) { 
    # wild card 
    $source =~ /\*|\[|\{/ 
        ? map File::Copy::copy($_ => $destination), bsd_glob("$source") 
        :     File::Copy::copy($source => $destination);  

    return $self
}

sub move ($self, $source, $destination) {
    # wild card 
    $source =~ /\*|\[|\{/ 
        ? map File::Copy::move($_ => $destination), bsd_glob("$source")
        :     File::Copy::move($source => $destination);  

    return $self
} 

sub wait ($self, $time) {
    sleep ($time); 
    
    return $self
} 

1
