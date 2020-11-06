package HPC::Sched::Resource; 

use Moose::Role; 
use MooseX::Aliases;  
use MooseX::Types::Moose qw(Str Int); 

use namespace::autoclean; 
use experimental 'signatures';  

requires qw(_set_omp _set_ngpus); 

has 'shell' => ( 
    is        => 'rw', 
    isa       =>  Str,
    traits    => ['Chained'],
    predicate => '_has_shell',
    default   => '#!/usr/bin/env bash'
); 

has 'name' => ( 
    alias     => 'job-name',
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_name',
    default   => 'test' 
); 

has 'app' => ( 
    alias     => 'comment',
    is        => 'rw', 
    required  => 1,
    traits    => ['Chained'],
    predicate => '_has_app',
); 

has 'queue' => ( 
    alias     => 'partition',
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_queue',
); 

has 'stderr' => ( 
    alias     => 'error',
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_stderr',
); 

has 'stdout' => ( 
    alias     => 'output',
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_stdout',
); 

has 'walltime' => (
    alias     => 'time',
    is        => 'rw',
    traits    => ['Chained'],
    predicate => '_has_walltime',
    default   => '48:00:00'
);

has 'select' => (
    alias     => 'nodes',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_select',
    default   => 1,
); 

has 'mpiprocs' => (
    alias     => 'ntasks-per-node',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_mpiprocs',
    clearer   => '_reset_mpiprocs', 
    default   => 1
);

has 'omp' => (
    alias     => 'cpus-per-task',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_omp',
    lazy      => 1,
    default   => 1, 
    trigger   => sub ($self, @) { 
        $self->_set_omp; 
    }
); 

has 'ngpus' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ngpus',
    lazy      => 1,
    default   => 1,
    trigger   => sub ($self, @) { 
        $self->_set_ngpus; 
    }
);

has 'burst_buffer' => (
    is        => 'ro',
    isa       => Int,
    predicate => '_has_burst_buffer',
    lazy      => 1,
    default   => 0
);

1
