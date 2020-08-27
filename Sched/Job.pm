package HPC::Sched::Job; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
    HPC::Debug::Dump 
    HPC::Io::Write 
    HPC::Sched::Env 
    HPC::Sched::Module 
    HPC::Sched::Resource 
    HPC::Sched::Cmd 
    HPC::Sched::Plugin
    HPC::Sched::Sys
); 

has 'submit_cmd' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
); 

has 'script' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef,
    lazy     => 1, 
    default  => 'run.sh', 
); 

sub write ( $self, $file = '' ) { 
    $file 
        ? $self->io_write($file) 
        : $self->io_write($self->script); 

    $self->write_resource
         ->write_module 
         ->write_env
         ->write_cmd; 

    return $self
} 

sub submit ( $self ) {
    system $self->submit_cmd, $self->script; 
    
    return $self
} 

sub _set_omp ($self,@) {
    # pass OMP_NUM_THREADS to MPI
    if ( $self->_has_mvapich2 ) { $self->mvapich2->omp($self->omp) }
    if ( $self->_has_openmpi  ) { $self->openmpi->omp($self->omp)  }

    # pass OMP_NUM_THREADS to Lammps Intel/Omp package cmd
    if ( $self->_has_lammps and $self->lammps->_has_intel ) { $self->lammps->intel->omp($self->omp)    }
    if ( $self->_has_lammps and $self->lammps->_has_omp   ) { $self->lammps->omp->nthreads($self->omp) }

    # pass OMP_NUN_THREADS to Gromacs cmd
    if ( $self->_has_gromacs ) { $self->gromacs->ntomp($self->omp) }
}

1
