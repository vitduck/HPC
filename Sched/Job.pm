package HPC::Sched::Job; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 

use namespace::autoclean;
use experimental 'signatures'; 

with qw( 
    HPC::Debug::Dump 
    HPC::Io::Write 
    HPC::Sched::Resource 
    HPC::Sched::Module HPC::Sched::Env 
    HPC::Sched::Ime HPC::Sched::Cmd 
    HPC::Sched::Plugin  HPC::Sched::Sys );

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

sub write ($self, $file = '') { 
    $file 
        ? $self->io_write($file) 
        : $self->io_write($self->script); 

    $self->write_resource
         ->write_module 
         ->write_env
         ->write_cmd; 

    return $self
} 

sub submit ($self) {
    system $self->submit_cmd, $self->script; 
    
    return $self
} 

sub _set_omp ($self,@) {
    # pass OMP_NUM_THREADS to MPI
    $self->mvapich2->omp($self->omp) if $self->_has_mvapich2;  
    $self->openmpi->omp($self->omp)  if $self->_has_openmpi; 

    # pass OMP_NUM_THREADS to Lammps Intel/Omp package cmd
    $self->lammps->intel->omp($self->omp)    if $self->_has_lammps and $self->lammps->_has_intel; 
    $self->lammps->omp->nthreads($self->omp) if $self->_has_lammps and $self->lammps->_has_omp; 

    # pass OMP_NUN_THREADS to Gromacs cmd
    $self->gromacs->ntomp($self->omp) if $self->_has_gromacs; 
}

1
