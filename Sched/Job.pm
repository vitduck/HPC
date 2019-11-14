package HPC::Sched::Job; 

use Moose;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::Types::Moose 'Str'; 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
    HPC::Debug::Dump 
    HPC::Sched::Write HPC::Sched::Sys 
    HPC::Sched::Module HPC::Sched::Path 
    HPC::Sched::Cmd ); 

has 'script' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef, 
    traits   => [ 'Chained' ],
    lazy     => 1, 
    default  => 'run.sh', 
    trigger  => sub ($self, $file, @) { $self->io_write($file) } 
); 

sub write ($self, $file) { 
    $self->script($file); 

    #$self->_write_resource;  
    $self->_write_module; 
    $self->_write_cmd; 

    return $self
} 

__PACKAGE__->meta->make_immutable;

1
