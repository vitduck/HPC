package HPC::PBS::Qsub; 

use Moose::Role; 

with 'HPC::PBS::Resource'; 
with 'HPC::PBS::IO'; 

has 'shell' => ( 
    is       => 'rw', 
    isa      => 'Str',
    default  => '#!/usr/bin/env bash', 
); 

has 'exported' => ( 
    is       => 'ro', 
    isa      => 'Bool',
    init_arg => undef, 
    default  => 1, 
); 

has 'project' => ( 
    is       => 'ro', 
    isa      => 'Str',
    init_arg => undef,
    default  => 'burst_buffer'
); 

has 'account' => ( 
    is       => 'ro', 
    isa      => 'Str',
    default  => 'etc',
); 

has 'queue' => ( 
    is       => 'ro', 
    isa      => 'Str',
    default  => 'normal'
); 

has 'name' => ( 
    is       => 'ro', 
    isa      => 'Str',
    default  => 'jobname'
); 

has 'cmd' => (
    is       => 'rw',
    traits   => ['Array'],
    isa      => 'ArrayRef[Str]',
    default  => sub {[]},   
    handles  => { 
        add_cmd  => 'push', 
        list_cmd => 'elements'
    }
);

sub _write_pbs { 
    my $self = shift; 

    # shell 
    $self->printf("%s\n", $self->shell); 
    $self->printf("\n"); 

    #  pbs header
    $self->printf("#PBS -V\n"); 
    $self->printf("#PBS -A %s\n", $self->account); 
    $self->printf("#PBS -P %s\n", $self->project); 
    $self->printf("#PBS -q %s\n", $self->queue); 
    $self->printf("#PBS -N %s\n", $self->name); 

    # resource 
    $self->printf(
        "#PBS -l select=%d:ncpus=%d:mpiprocs=%d:ompthreads=%d\n", 
        $self->select, 
        $self->ncpus, 
        $self->mpiprocs,
        $self->ompthreads
    ); 
    $self->printf("#PBS -l walltime=%s\n", $self->walltime); 
    $self->printf("\n"); 

    # command 
    for my $cmd ($self->list_cmd) { 
        $self->printf("$cmd\n"); 
    } 
} 

sub qsub { 
    my $self = shift; 

    system 'qsub', $self->pbs; 
} 

1
