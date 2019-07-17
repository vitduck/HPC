package HPC::PBS::IO; 

use Moose::Role; 
use Moose::Util::TypeConstraints;

use IO::File; 

subtype 'IO' 
    => as 'Object';  

coerce 'IO'
    => from 'Str'
    => via { return IO::File->new($_, 'w') }; 

has 'pbs' => (
    is       => 'rw',
    isa      => 'Str',
    init_arg => undef,
    trigger  => sub { 
        my $self = shift; 

        $self->_clear_io; 
        $self->io($self->pbs);
        $self->_write_pbs; 
    }
); 

has 'io' => (
    is       => 'rw',
    isa      => 'IO',
    init_arg => undef,
    coerce   => 1, 
    clearer  => '_clear_io', 
    handles  => [qw(print printf)], 
); 


1
