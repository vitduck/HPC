package HPC::PBS::Qsub; 

use Moose::Role; 
use feature 'switch'; 

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
    trigger => sub {
        my $self = shift;
        $self->_reset_mpiprocs;
        $self->mpiprocs;
    }
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
    trigger => sub {
        my $self = shift;

        # recalculate mpiprocs 
        $self->_reset_mpiprocs;
        $self->mpiprocs;

        # rebuild mpirun 
        $self->_reset_mpirun; 
    }
);

has 'walltime' => (
    is      => 'rw',
    isa     => 'Str',
    default => '48:00:00',
);

has 'bin' => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub { 
        my $self= shift; 

        $self->_reset_mpirun; 
        $self->_reset_cmd; 
    }
); 

has 'cmd' => (
    is       => 'rw',
    traits   => ['Array'],
    isa      => 'ArrayRef[Str]',
    default  => sub {[]},
    handles  => {
           add_cmd => 'push',
          list_cmd => 'elements', 
        _reset_cmd => 'clear'
    }
);

has 'mpirun' => ( 
    is       => 'rw', 
    isa      => 'Str',
    lazy     => 1, 
    init_arg => undef, 
    builder  => '_build_mpirun', 
    clearer  => '_reset_mpirun', 
); 

sub _build_mpirun { 
    my $self = shift; 

    my $mpirun = 
        $self->has_impi      ? 'mpirun' : 
        $self->has_openmpi   ? $self->openmpi->mpirun ($self->ompthreads) : 
        $self->has_mvapich2  ? $self->mvapich2->mpirun($self->select, $self->ncpus, $self->ompthreads) : 
        undef; 

    return 
        $mpirun ? join ' ', $mpirun, $self->bin : $self->bin
} 

1
