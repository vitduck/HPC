package HPC::PBS::Resource; 

use Moose::Role; 
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/Str Int/; 

has 'shell' => ( 
    is      => 'rw', 
    isa     =>  Str,
    writer  => 'set_shell',
    default => '#!/usr/bin/env bash', 
); 

has 'project' => ( 
    is       => 'ro', 
    isa      => Str,
    init_arg => undef,
    default  => 'burst_buffer'
); 

has 'account' => ( 
    is      => 'rw', 
    isa     => enum([qw(ansys abaqus lsdyna nastran gaussian
                         openfoam wrf cesm mpas roms grims mom vasp gromacs charmm
                         amber lammps namd qe qmc bwa cam inhouse tf caffe pytorch etc)]), 
    writer  => 'set_account',
    default => 'etc',
); 

has 'queue' => ( 
    is      => 'rw', 
    isa     => enum([qw(exclusive khoa rokaf_knl normal long flat debug  commercial norm_skl)]), 
    writer  => 'set_queue',
    default => 'normal'
); 

has 'name' => ( 
    is      => 'rw', 
    isa     => Str, 
    writer  => 'set_name',
    default => 'jobname', 
); 

has 'select' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_select',
    trigger => sub { 
        my $self = shift; 

        $self->_reset_mpiprocs; 

        if ($self->has_mpi) {  
            $self->mpi->set_nprocs($self->select*$self->mpiprocs) 
        }
    }
);

has 'ncpus' => (
    is      => 'rw',
    isa     => Int,
    default => 1,
    writer  => 'set_ncpus',
    trigger => sub { 
        my $self = shift; 

        $self->_reset_mpiprocs;  

        if ($self->has_mpi) {  
            $self->mpi->set_nprocs($self->select*$self->mpiprocs) 
        }
    }
);

has 'stderr' => ( 
    is     => 'rw', 
    isa    => Str,
    writer => 'set_stderr',
); 

has 'stdout' => ( 
    is     => 'rw', 
    isa    => Str,
    writer => 'set_stdout',
); 

has 'mpiprocs' => (
    is      => 'rw',
    isa     => Int,
    lazy    => 1,
    writer  => 'set_mpiprocs',
    clearer => '_reset_mpiprocs', 
    default => sub { 
        my $self = shift; 

        $self->has_omp 
        ? $self->ncpus / $self->omp
        : $self->ncpus
    }
);

has 'omp' => (
    is        => 'rw',
    isa       => Int,
    lazy      => 1, 
    default   => 1,
    predicate => 'has_omp',
    writer    => 'set_omp',
    clearer   => '_reset_omp', 
    trigger   => sub { 
        my $self = shift; 

        $self->_reset_mpiprocs; 

        if ($self->has_mpi) { 
            $self->mpi->set_nprocs($self->select*$self->mpiprocs); 
            $self->mpi->set_omp($self->omp); 
        } 
    }
);

has 'walltime' => (
    is      => 'rw',
    isa     => Str,
    default => '48:00:00',
    writer  => 'set_walltime',
);

sub _write_pbs_opt {
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

    # optional
    $self->printf("#PBS -e %s\n", $self->stderr) if $self->stderr;
    $self->printf("#PBS -o %s\n", $self->stdout) if $self->stdout;

    # resource
    $self->printf(
        "#PBS -l select=%d:ncpus=%d:mpiprocs=%d:ompthreads=%d\n",
        $self->select,
        $self->ncpus,
        $self->mpiprocs,
        $self->omp
    );

    $self->printf("#PBS -l walltime=%s\n", $self->walltime);
    $self->printf("\n");
}

1
