package HPC::Sched::Job; 

use Moose::Role;  
use MooseX::Types::Moose 'Str'; 

use namespace::autoclean;
use experimental 'signatures'; 

with qw( 
    HPC::Debug::Dump 
    HPC::Io::Write 
    HPC::Sched::Resource
    HPC::Sched::Module HPC::Sched::Env 
    HPC::Sched::Ime HPC::Sched::Cmd 
    HPC::Sched::Plugin  HPC::Sched::Sys );

has 'script' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef,
    lazy     => 1, 
    default  => 'run.sh', 
); 

sub write ($self, $file = '') { 
    $file 
        ? $self->io_write($file) 
        : $self->io_write($self->script); 

    $self->write_resource 
         ->write_module 
         ->write_env
         ->write_cmd;

    return $self
}

1
