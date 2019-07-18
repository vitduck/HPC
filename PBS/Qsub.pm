package HPC::PBS::Qsub; 

use Moose::Role; 
use feature 'switch'; 

has 'shell' => ( 
    is       => 'rw', 
    isa      => 'Str',
    default  => '#!/usr/bin/env bash', 
); 

has 'project' => ( 
    is       => 'ro', 
    isa      => 'Str',
    init_arg => undef,
    default  => 'burst_buffer'
); 

has 'account' => ( 
    is       => 'rw', 
    isa      => 'Str',
    default  => 'etc',
); 

has 'queue' => ( 
    is       => 'rw', 
    isa      => 'Str',
    default  => 'normal'
); 

has 'name' => ( 
    is       => 'rw', 
    isa      => 'Str',
    default  => 'jobname'
); 

has 'select' => (
    is       => 'rw',
    isa      => 'Int',
    default  => 1,
);

has 'ncpus' => (
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

has 'stderr' => ( 
    is       => 'rw', 
    isa      => 'Str',
); 

has 'stdout' => ( 
    is       => 'rw', 
    isa      => 'Str',
); 

has 'mpiprocs' => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
        my $self = shift;

        return $self->ncpus / $self->ompthreads
    },
    clearer => '_reset_mpiprocs'
);

has 'ompthreads' => (
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

has 'walltime' => (
    is      => 'rw',
    isa     => 'Str',
    default => '48:00:00',
);

after [qw(ncpus ompthreads)] => sub { 
    my $self = shift; 

    $self->_reset_mpiprocs;
    $self->_reset_mpirun; 
};  

1
