package HPC::PBS::Qsub; 

use Moose::Role; 
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/Str Int/; 

has 'shell' => ( 
    is       => 'rw', 
    isa      =>  Str,
    default  => '#!/usr/bin/env bash', 
); 

has 'project' => ( 
    is       => 'ro', 
    isa      => Str,
    init_arg => undef,
    default  => 'burst_buffer'
); 

has 'account' => ( 
    is       => 'rw', 
    isa      => enum([qw(
        ansys abaqus lsdyna nastran gaussian
        openfoam wrf cesm mpas roms grims mom vasp gromacs charmm
        amber lammps namd qe qmc bwa cam inhouse tf caffe pytorch etc)
    ]), 
    default  => 'etc',
); 

has 'queue' => ( 
    is       => 'rw', 
    isa      => enum([qw(
        exclusive khoa rokaf_knl normal long flat debug
        commercial norm_skl) 
    ]), 
    default  => 'normal'
); 

has 'name' => ( 
    is       => 'rw', 
    isa      => Str, 
    default  => 'jobname'
); 

has 'select' => (
    is       => 'rw',
    isa      => Int,
    default  => 1,
    trigger => sub { shift->_reset_mpiprocs } 
);

has 'ncpus' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    trigger => sub { shift->_reset_mpiprocs } 
);

has 'stderr' => ( 
    is        => 'rw', 
    isa       => Str,
    predicate => 'has_stderr'
); 

has 'stdout' => ( 
    is        => 'rw', 
    isa       => Str,
    predicate => 'has_stdout'
); 

has 'mpiprocs' => (
    is      => 'rw',
    isa     => Int,
    lazy    => 1,
    default => sub {
        my $self = shift;

        return $self->ncpus / $self->omp
    },
    clearer => '_reset_mpiprocs'
);

has 'omp' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    trigger => sub { shift->_reset_mpiprocs } 
);

has 'walltime' => (
    is      => 'rw',
    isa     => Str,
    default => '48:00:00',
);

1
