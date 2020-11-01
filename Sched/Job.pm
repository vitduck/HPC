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

sub _set_omp ($self) {
    $self->_set_openmpi_omp 
         ->_set_mvapich2_omp 
         ->_set_lammps_omp
         ->_set_gromacs_omp
}

sub _set_ngpus ($self) { 
    $self->_set_lammps_gpu    
} 

sub _set_openmpi_omp ($self) { 
    my $omp = $self->omp =~ s/.*(\d+)$/$1/r; 

    $self->openmpi->omp($omp) if $self->_has_openmpi; 

    return $self; 
}

sub _set_mvapich2_omp ($self) { 
    my $omp = $self->omp =~ s/.*(\d+)$/$1/r; 

    $self->mvapich2->omp($omp) if $self->_has_mvapich2; 
    
    return $self; 
}

sub _set_lammps_omp ($self) { 
    my $omp = $self->omp =~ s/.*(\d+)$/$1/r; 

    $self->lammps->intel->omp($omp)    if $self->_has_lammps and $self->lammps->_has_intel; 
    $self->lammps->omp->nthreads($omp) if $self->_has_lammps and $self->lammps->_has_omp; 
    
    return $self; 
} 

sub _set_gromacs_omp ($self) { 
    my $omp = $self->omp =~ s/.*(\d+)$/$1/r; 

    $self->gromacs->ntomp($omp) if $self->_has_gromacs; 
    
    return $self; 
} 

sub _set_lammps_gpu ($self) { 
    my $ngpus = $self->ngpus =~ s/.*(\d+)$/$1/r; 

    $self->lammps->gpu->ngpu($ngpus) if $self->_has_lammps and $self->lammps->_has_gpu; 

    return $self; 
} 

1
