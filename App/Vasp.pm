package HPC::App::Vasp;  

use Moose; 
use MooseX::Types::Moose 'Str'; 
use MooseX::Aliases;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 

use experimental 'signatures'; 
use namespace::autoclean;

with qw(
    HPC::Debug::Dump
    HPC::Io::Read
    HPC::Io::Write
    HPC::Plugin::Cmd
    HPC::App::Vasp::Incar);

has '+io_read' => (
    lazy    => 1, 
    default => sub ($self) { 
        $self->_has_input_dir ? join('/', $self->input_dir, 'INCAR') : 'INCAR' 
    } 
); 

has '+io_write' => (
    lazy    => 1, 
    default   => sub ($self) { 
        $self->_has_input_dir ? join('/', $self->input_dir, 'INCAR') : 'INCAR' 
    } 

); 

has 'input_dir' => ( 
    is        => 'rw', 
    isa       => Str, 
    traits    => ['Chained'], 
    predicate => '_has_input_dir', 
    default   => './template'
); 

sub _opts {
    return qw()
}

__PACKAGE__->meta->make_immutable;

1
