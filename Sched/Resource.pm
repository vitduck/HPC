package HPC::Sched::Resource; 

use Moose::Role; 
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

has 'account' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_account',
    default   => 'etc',
); 

has 'queue' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_queue',
); 

has 'name' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_name',
    default   => 'test' 
); 

has 'stderr' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_stderr',
); 

has 'stdout' => ( 
    is        => 'rw', 
    traits    => ['Chained'],
    predicate => '_has_stdout',
); 

has 'walltime' => (
    is        => 'rw',
    traits    => ['Chained'],
    predicate => '_has_walltime',
    default   => '48:00:00'
);

has 'select' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_select',
    default   => 1,
);

has 'ncpus' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ncpus',
    default   => 64,
);

1
