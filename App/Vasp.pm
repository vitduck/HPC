package HPC::App::Vasp;  

use Moose; 
use MooseX::Types::Moose 'Str'; 
use MooseX::Aliases;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 

use namespace::autoclean;
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

with qw(
    HPC::Debug::Dump
    HPC::Io::Read
    HPC::Io::Write
    HPC::Plugin::Cmd
    HPC::App::Vasp::Incar );

has '+io_read' => (
    lazy    => 1, 
    default => sub ($self) { 
        $self->_has_template ? join('/', $self->template, 'INCAR') : 'INCAR' 
    } 
); 

has '+io_write' => (
    lazy    => 1, 
    default   => sub ($self) { 
        $self->_has_template ? join('/', $self->template, 'INCAR') : 'INCAR' 
    } 

); 

has 'template' => ( 
    is        => 'rw', 
    isa       => Str, 
    traits    => ['Chained'], 
    predicate => '_has_template', 
    lazy      => 1, 
    default   => './template'
); 

sub _opts {
    return qw()
}

__PACKAGE__->meta->make_immutable;

1
