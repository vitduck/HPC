package HPC::Plugin::Vasp;  

use Moose; 
use MooseX::Aliases;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use namespace::autoclean;
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

with qw(
    HPC::Debug::Dump
    HPC::Sched::Read
    HPC::Sched::Write
    HPC::Plugin::Cmd
    HPC::Plugin::Vasp::Incar );

has '+io_read' => (
    lazy    => 1, 
    default => 'INCAR'
); 

has '+io_write' => (
    lazy    => 1, 
    default => 'INCAR'
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
