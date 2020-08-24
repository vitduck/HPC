package HPC::Sched::Sys; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str HashRef); 
use File::Copy ();  
use File::Path qw(make_path); 
use File::Glob ':bsd_glob';  
use Cwd qw(abs_path);

use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'root' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
    default  => sub ( $self ) { abs_path('.') }
); 

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

sub timing ($self) { 
    return { time => ['-p'] }
} 

sub echo ($self, $message) { 
    printf("%s\n", $message); 

    return $self
} 

sub wait ($self, $time) {
    sleep ($time); 
    
    return $self
} 

1
