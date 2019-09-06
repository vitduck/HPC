package HPC::PBS::IO; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str FileHandle); 

use IO::File; 

has 'pbs' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef, 
    writer   => 'write', 
    trigger  => sub { 
        my $self = shift; 

        # write to fh
        $self->set_fh(IO::File->new($self->pbs, 'w')); 

        $self->_write_pbs_resource; 
        $self->_write_pbs_module; 
        $self->_write_pbs_cmd; 

        # close fh 
        $self->close; 

        # reset pbs_cmd
        $self->_reset_cmd; 
    } 
); 

has 'fh' => ( 
    is       => 'rw', 
    isa      => FileHandle, 
    init_arg => undef, 
    writer   => 'set_fh',
    handles  => [ qw(print printf close) ]
); 

1; 
