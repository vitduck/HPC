package HPC::PBS::IO; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str FileHandle); 

use IO::File; 

has 'pbs' => ( 
    is       => 'rw', 
    isa      => Str, 
    traits   => ['Chained'],
    init_arg => undef, 
    writer   => 'write', 
    trigger  => sub { 
        my $self = shift; 

        # write to fh
        $self->fh(
            IO::File->new($self->pbs, 'w')
        ); 

        $self->_write_pbs_resource; 
        $self->_write_pbs_module; 
        $self->_write_pbs_cmd; 

        # close fh 
        $self->close; 

        # reset pbs_cmd
        $self->reset_cmd; 
    } 
); 

has 'fh' => ( 
    is       => 'rw', 
    isa      => FileHandle, 
    init_arg => undef, 
    handles  => [ qw(print printf close) ]
); 

1; 
