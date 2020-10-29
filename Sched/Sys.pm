package HPC::Sched::Sys; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str HashRef); 

use Cwd 'abs_path';
use File::Copy ();  
use File::Path 'make_path'; 
use File::Glob ':bsd_glob';  

use namespace::autoclean; 
use experimental 'signatures'; 

has 'root' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
    default  => sub ( $self ) { abs_path('.') }
); 

has scratch => ( 
    is       => 'rw',    
    isa      => Str, 
    init_arg => undef,
    lazy     => 1, 
    default  => sub { shift->root },  
    trigger  => sub ( $self, $scratch, @ ) { 
        $self->scratch_ime( $scratch =~ s/scratch/scratch_ime/r )
    } 
); 

has scratch_ime => (
    is       => 'rw',    
    isa      => Str, 
    init_arg => undef,
    lazy     => 1, 
    default  => sub ( $self ) { 
        $self->scratch =~ s/scratch/scratch_ime/r; 
    }
); 

sub mkdir ($self, @dirs) { 
    make_path($_) for @dirs; 

    return $self
} 

sub chdir ($self, $dir) { 
    chdir($dir); 

    $self->scratch( abs_path('.') ); 

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
