package HPC::App::Vasp;  

use Moose; 
use MooseX::Aliases;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use HPC::App::Types::Vasp qw(IO_Read IO_Write); 
use namespace::autoclean;
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data 
    HPC::App::Vasp::Incar );

has 'io_read' => ( 
    is       => 'rw', 
    isa      => IO_Read, 
    init_arg => undef,
    clearer  => '_close_io_read',
    coerce   => 1, 
    lazy     => 1, 
    default  => 'INCAR',
    handles  => [qw(getline getlines)]
); 

has 'io_write' => ( 
    is       => 'rw', 
    isa      => IO_Write, 
    init_arg => undef,
    clearer  => '_close_io_write',
    coerce   => 1, 
    lazy     => 1, 
    default  => 'INCAR',
    handles  => [qw(print printf)]
); 

sub _get_opts {
    return qw()
}

sub BUILD ($self,@) { 
    # cache INCAR file
    $self->io_read('INCAR'); 
    $self->incar;  

    $self->_close_io_read
} 

__PACKAGE__->meta->make_immutable;

1
