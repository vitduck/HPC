package HPC::Sched::Sys; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str HashRef); 

use Cwd 'abs_path';
use File::Path 'make_path'; 
use File::Copy::Recursive qw(rcopy rcopy_glob rmove rmove_glob); 
use String::Wildcard::Bash 'contains_wildcard'; 

use HPC::Types::Ime::Ctl 'Scratch_Ime'; 

use namespace::autoclean; 
use experimental 'signatures'; 

has 'root' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
    default  => sub ( $self ) { abs_path('.') }
); 

has scratch_ime => (
    is       => 'rw',    
    isa      => Scratch_Ime, 
    init_arg => undef,
    coerce   => 1, 
    lazy     => 1, 
    default  => sub ($self) { 
        $self->root
    }
); 

sub mkdir ($self, @dirs) { 
    make_path($_) for @dirs; 

    return $self
} 

sub chdir ($self, $dir) { 
    chdir($dir); 

    $self->scratch_ime( abs_path('.') ) if $self->_has_burst_buffer;  

    return $self
} 

sub copy ($self, $source, $destination) { 
    contains_wildcard($source) 
        ? rcopy_glob($source => $destination) 
        : rcopy     ($source => $destination); 

    return $self
}

sub move ($self, $source, $destination) {
    contains_wildcard($source) 
        ? rmove_glob($source => $destination) 
        : rmove     ($source => $destination); 

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
