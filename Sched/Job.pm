package HPC::Sched::Job; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
    HPC::Debug::Dump 
    HPC::Io::Write 
    HPC::Sched::Env 
    HPC::Sched::Path 
    HPC::Sched::Module 
    HPC::Sched::Resource 
    HPC::Sched::Cmd 
    HPC::Sched::Plugin
    HPC::Sched::Sys
    HPC::Sched::Iterator
); 

has 'submit_cmd' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
); 

has 'submit_dir' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
); 

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
    $self->script($file) 
         ->write_resource
         ->write_module 
         ->write_env
         ->write_cmd; 

    return $self
} 

sub run ($self) {
    system $self->submit_cmd, $self->script; 
    
    return $self
} 

1
