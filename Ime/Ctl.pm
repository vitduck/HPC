package HPC::Ime::Ctl; 

use Moose::Role; 
use MooseX::Types::Moose 'ArrayRef'; 
use HPC::Types::Ime::Ctl qw(Ime_Block Ime_Verbose Ime_File Ime_Dir); 

use namespace::autoclean; 
use experimental 'signatures'; 

has blocking => ( 
    is      => 'rw', 
    isa     => Ime_Block, 
    lazy    => 1, 
    coerce  => 1,  
    default => 1, 
    trigger => sub ($self, @) { 
        $self->add_ime_option($self->blocking) 
    } 
);

has verbose => ( 
    is      => 'rw', 
    isa     => Ime_Verbose, 
    lazy    => 1, 
    coerce  => 1,  
    default => 1, 
    trigger => sub ($self, @) { 
        $self->add_ime_option($self->verbose) 
    } 
);

has file => (
    is        => 'rw', 
    isa       => Ime_File, 
    predicate => '_has_file',
    lazy      => 1, 
    coerce    => 1, 
    default   => sub{[]}, 
); 

has dir => ( 
    is    => 'rw', 
    isa   => Ime_Dir, 
    predicate => '_has_dir',
    lazy    => 1, 
    coerce  => 1, 
    default => sub{[]},
); 

has option => (
    is      => 'rw', 
    isa     =>  ArrayRef, 
    traits  => ['Array'],
    lazy    => 1,  
    default => sub {[]}, 
    handles => { 
        add_ime_option   => 'push', 
        list_ime_options => 'elements'
    }
); 

sub cmd ($self) { 
    my @cmd = ();  

    push @cmd, join(' ', 'ime-ctl', $self->list_ime_options, $self->file)       if $self->_has_file; 
    push @cmd, join(' ', 'ime-ctl', $self->list_ime_options, '-R', $self->dir)  if $self->_has_dir; 

    return [@cmd]; 
} 

1
