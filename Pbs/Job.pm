package HPC::Pbs::Job;  

use Moose;
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::Types::Moose qw(Str Int);
use MooseX::XSAccessor; 
use HPC::Types::Sched::Pbs qw(Account Name Queue Stdout Stderr Walltime); 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
     HPC::Sched::Job 
     HPC::Pbs::Resource ); 

has '+submit_cmd' => (
    default => 'qsub'
); 

# has '+submit_dir' => (
    # default => $ENV{PBS_O_WORKDIR}
# ); 

has '+name' => (
    isa     => Name, 
    coerce  => 1, 
); 

has '+account' => ( 
    isa     => Account, 
    coerce  => 1, 
); 

has '+queue' => ( 
    isa     => Queue, 
    coerce  => 1, 
    default => 'normal'
); 

has '+stderr' => ( 
    isa     => Stderr, 
    coerce  => 1, 
); 

has '+stdout' => ( 
    isa     => Stdout, 
    coerce  => 1, 
); 

has '+walltime' => ( 
    isa     => Walltime, 
    coerce  => 1, 
    default => '48:00:00'
); 

has '+select' => ( 
    trigger => sub ($self, @) {
        $self->_reset_resource;
        $self->mvapich2->nprocs($self->select*$self->mpiprocs) if $self->_has_mvapich2;
    }
); 

has '+ncpus' => ( 
    trigger => sub ($self,@) { 
        $self->_reset_resource; 
        $self->mvapich2->nprocs($self->select*$self->mpiprocs) if $self->_has_mvapich2
    }
); 

has '+mpiprocs' => (
    lazy      => 1,
    default   => sub ($self, @) { $self->ncpus } 
);

has '+omp' => (
    trigger   => sub ($self, @) { 
        $self->_reset_resource; 
        $self->mvapich2->nprocs($self->select*$self->mpiprocs)->omp($self->omp) if $self->_has_mvapich2; 
        $self->openmpi->omp($self->omp)                                             if $self->_has_openmpi;  
    }
);

has '+cmd' => ( 
    default => sub { ['cd $PBS_O_WORKDIR'] }
); 

has '+openmpi' => ( 
    trigger   => sub ($self, @) { 
        $self->openmpi->omp($self->omp) if $self->_has_omp 
    }
); 

has '+mvapich2' => ( 
    trigger   => sub ($self, @) {
        $self->mvapich2->nprocs($self->select*$self->mpiprocs);
        $self->mvapich2->omp($self->omp) if $self->_has_omp; 
    }
); 

sub write_resource ($self) {
    $self->printf("%s\n\n", $self->shell);

    # build resource string
    $self->resource; 
    for (qw(export name account project queue stderr stdout resource walltime)) {
        my $has = "_has_$_";
        $self->printf("%s\n", $self->$_) if $self->$has;
    }

    return $self
}

__PACKAGE__->meta->make_immutable;

1
