package HPC::Sched::Resource; 

use Moose::Role; 
use MooseX::Aliases;  
use MooseX::Types::Moose qw(Str Int HashRef); 

use namespace::autoclean; 
use experimental 'signatures';  

has shell => ( 
    is        => 'rw', 
    isa       => Str,
    init_arg  => undef, 
    traits    => ['Chained'],
    predicate => '_has_shell',
    default   => '#!/usr/bin/env bash'
); 

has name => ( 
    alias     => 'job-name',
    is        => 'rw', 
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_name',
    default   => 'test',  
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
    } 
); 

has app => ( 
    alias     => 'comment',
    is        => 'rw', 
    isa       => Str,
    required  => 1,
    traits    => ['Chained'],
    predicate => '_has_app',
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
    } 
); 

has queue => ( 
    alias     => 'partition',
    is        => 'rw', 
    isa       => Str,
    required  => 1, 
    traits    => ['Chained'],
    predicate => '_has_queue',
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
    } 
); 

has stderr => (
    alias     => 'error',
    is        => 'rw', 
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_stderr',
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
    } 
); 

has stdout => ( 
    alias     => 'output',
    is        => 'rw', 
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_stdout',
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
    } 
); 

has walltime => (
    alias     => 'time',
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_walltime',
    default   => '48:00:00', 
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
    } 
);

has select => (
    alias     => 'nodes',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_select',
    default   => 1,
    trigger   => sub ($self, $select, $=) { 
        $self->_unset_option; 

        $self->nprocs($select * $self->mpiprocs);  
    } 
); 

has mpiprocs => (
    alias     => 'ntasks-per-node',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_mpiprocs',
    default   => 1, 
    trigger   => sub ($self, $mpiprocs, $=) { 
        $self->_unset_option; 

        $self->nprocs($self->select * $mpiprocs);  
    } 
);

has omp => (
    alias     => 'cpus-per-task',
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_omp',
    lazy      => 1,
    default   => 1, 
    trigger   => sub ($self, $omp, $=) { 
        $self->_unset_option; 

        # mpi
        if ($self->_has_impi    ) { $self->impi->omp($omp)     }
        if ($self->_has_openmpi ) { $self->openmpi->omp($omp)  }
        if ($self->_has_mvapich2) { $self->mvapich2->omp($omp) }

        # lammps
        if ($self->_has_lammps ) { 
            if ( $self->lammps->_has_omp    ) { $self->lammps->omp->nthreads($omp) }
            if ( $self->lammps->_has_intel  ) { $self->lammps->intel->omp($omp)    } 

            # affinity for kokkos package
            if ( $self->lammps->_has_kokkos and $omp > 1 ) {  
                $self->lammps->kokkos_thr($omp); 
                
                $self->set_env( 
                    OMP_PROC_BIND => 'spread',  
                    OMP_PLACES    => 'threads' ); 
            }
        }

        # gromacs 
        if ( $self->_has_gromacs ) { $self->gromacs->ntomp($omp) }
    }
); 

has nprocs => ( 
    alias     => 'ntasks', 
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'], 
    predicate => '_has_nprocs',
    clearer   => '_unset_nprocs', 
    lazy      => 1, 
    default   => sub ($self) { 
        $self->select * $self->mpiprocs
    }, 
    trigger   => sub ($self, $nprocs, $=) { 
        # mpi
        $self->impi->nprocs($nprocs)     if $self->_has_impi;  
        $self->openmpi->nprocs($nprocs)  if $self->_has_openmpi; 
        $self->mvapich2->nprocs($nprocs) if $self->_has_mvapich2; 
    } 
); 

has ngpus => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ngpus',
    lazy      => 1,
    default   => 1,
    trigger   => sub ($self, $ngpus, $=) { 
        $self->_unset_option; 
    
        # lammps gpu package
        $self->lammps->gpu->ngpu($ngpus) if $self->_has_lammps and $self->lammps->_has_gpu; 
    }
);

has burst_buffer => (
    is        => 'ro',
    isa       => Int,
    predicate => '_has_burst_buffer',
    lazy      => 1,
    default   => 0, 
);

has _option => (
    is       => 'rw', 
    isa      => HashRef, 
    traits   => ['Hash'],
    init_arg => undef,
    clearer  => '_unset_option', 
    lazy     => 1, 
    default  => sub ($self) { 
        my %option; 
        my $predicate; 

        for ( $self->_sched_options ) {
            $predicate  = "_has_$_"; 
            $option{$_} = $self->$_ if $self->$predicate; 
        }

        return { %option }
    }, 
    handles  => { 
        _set_sched_opt  => 'set', 
        _get_sched_opt  => 'get', 
        _list_sched_opt => 'keys', 
        _has_sched_opt  => 'defined'
    }, 

); 

sub write_resource ($self) {
    $self->printf("%s\n\n", $self->shell);

    for ( $self->_sched_options ) {
        next unless $self->_has_sched_opt($_); 

        $self->printf("%s\n", $self->_get_sched_opt($_))
    }

    $self->printf("\n");

    return $self
}

1
