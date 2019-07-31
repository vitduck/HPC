package HPC::PBS::Resource; 

use Moose::Role; 
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/Str Int/; 

has 'shell' => ( 
    is       => 'rw', 
    isa      =>  Str,
    writer   => 'set_shell',
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
        amber lammps namd qe qmc bwa cam inhouse tf caffe pytorch etc )
    ]), 
    writer   => 'set_account',
    default  => 'etc',
); 

has 'queue' => ( 
    is       => 'rw', 
    isa      => enum([qw( 
        exclusive khoa rokaf_knl normal long flat debug
        commercial norm_skl )
    ]), 
    writer   => 'set_queue',
    default  => 'normal'
); 

has 'name' => ( 
    is       => 'rw', 
    isa      => Str, 
    writer   => 'set_name',
    default  => 'jobname', 
); 

has 'select' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_select',
    trigger => sub { $_[0]->_reset_mpiprocs }
);

has 'ncpus' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_ncpus',
    trigger => sub { $_[0]->_reset_mpiprocs }
);

has 'stderr' => ( 
    is        => 'rw', 
    isa       => Str,
    writer  => 'set_stderr',
); 

has 'stdout' => ( 
    is      => 'rw', 
    isa     => Str,
    writer  => 'set_stdout',
); 

has 'mpiprocs' => (
    is      => 'rw',
    isa     => Int,
    lazy    => 1,
    default => sub { $_[0]->ncpus / $_[0]->omp }, 
    writer  => 'set_mpiprocs',
    clearer => '_reset_mpiprocs'
);

has 'omp' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_omp',
    trigger => sub { $_[0]->_reset_mpiprocs }
);

has 'walltime' => (
    is      => 'rw',
    isa     => Str,
    default => '48:00:00',
    writer  => 'set_walltime',
);

1
