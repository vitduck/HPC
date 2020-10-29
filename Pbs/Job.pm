package HPC::Pbs::Job;  

use Moose;
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw(Str Int);
use HPC::Types::Sched::Pbs qw(App Name Queue Stdout Stderr Walltime); 

use experimental 'signatures';
use namespace::autoclean;

with qw(
    HPC::Sched::Job 
    HPC::Pbs::Resource); 

has '+submit_cmd' => (
    default => 'qsub'
); 

has '+name' => (
    isa     => Name, 
    coerce  => 1, 
); 

has '+app' => ( 
    isa     => App, 
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
        $self->_reset_resource 
    } 
); 

has '+mpiprocs' => (
    lazy      => 1,
    default   => sub ($self, @) { 
        $self->omp 
            ? $self->ncpus / $self->omp 
            : $self->ncpus } 
);

has '+openmpi' => (
    trigger   => sub ($self, @) { 
        if ($self->_has_omp) { $self->openmpi->omp($self->omp) } 
    } 
); 
  
has '+mvapich2' => ( 
    trigger   => sub ($self, @) { 
        if ($self->_has_omp) { $self->mvapich2->omp($self->omp) }

        $self->mvapich2->hostfile('$PBS_NODEFILE') 
                       ->nprocs('$(wc -l $PBS_NODEFILE | awk \'{print $1}\')'); 
    } 
);  

before _set_omp => sub ($self) {  
    $self->_reset_resource; 
    $self->_reset_mpiprocs; 
}; 

__PACKAGE__->meta->make_immutable;

1
