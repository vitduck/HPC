package HPC::Sched::Resource; 

use Moose::Role; 
use MooseX::Aliases;  
use MooseX::Types::Moose qw(Str Int); 

use feature 'signatures';  
no warnings 'experimental::signatures'; 

requires 'write_resource'; 

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

has 'account' => ( 
    alias     => 'comment',
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_account',
    default   => 'etc',
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
);

has 'omp' => (
    alias     => 'cpus-per-task',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_omp',
    default   => 0
); 

1
