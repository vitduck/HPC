package HPC::Slurm::Job;  

use Moose;
use MooseX::Aliases; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::Types::Moose qw(Str Int);
use MooseX::XSAccessor; 
use HPC::Types::Sched::Slurm qw(Name Partition Nodes Cpus_per_Task Tasks_per_Node Time Error Output Comment); 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

with qw(
    HPC::Sched::Job 
    HPC::Slurm::Resource
    HPC::Slurm::Srun ); 

has '+name' => ( 
    isa     => Name, 
    coerce  => 1, 
); 

has '+account' => ( 
    # alias   => 'comment',
    isa     => Comment,
    coerce  => 1, 
); 

has '+queue' => ( 
    # alias   => 'partition',
    isa     => Partition, 
    coerce  => 1, 
    default => 'normal'
); 

has '+select' => ( 
    # alias   => 'nodes',
    isa     => Nodes,
    coerce  => 1, 
    trigger => sub ($self, $select, @) { 
        my $mpiprocs; 

        $select   = $1 if $self->select   =~ /(\d+)/; 
        $mpiprocs = $1 if $self->mpiprocs =~ /(\d+)/; 

        $self->_clear_ntasks;  
        $self->ntasks($select*$mpiprocs)
    } 
);

has '+mpiprocs' => ( 
    # alias  => 'ntasks_per_node',  
    isa    => Tasks_per_Node, 
    coerce => 1, 
    trigger => sub ($self, $mpiprocs, @) { 
        my $select; 

        $select   = $1 if $self->select   =~ /(\d+)/; 
        $mpiprocs = $1 if $self->mpiprocs =~ /(\d+)/; 

        $self->_clear_ntasks;  
        $self->ntasks($select*$mpiprocs)
    } 
);

has '+omp' => ( 
    # alias  => 'cpus_per_task', 
    isa    => Cpus_per_Task, 
    coerce => 1
); 

has '+stderr' => ( 
    # alias   => 'error',
    isa     => Error, 
    coerce  => 1, 
    default => '%s_%j.err'
); 

has '+stdout' => ( 
    # alias   => 'output',
    isa     => Output, 
    coerce  => 1, 
    default => '%s_%j.out'
); 

has '+walltime' => ( 
    # alias   => 'time',
    isa     => Time, 
    coerce  => 1, 
    default => '24:00:00'
); 

before 'write' => sub ($self, @) { 
    my ($mpi, %env);  

    if ($self->_has_mpi) { 
        $mpi = $self->_get_mpi; 

        # deref MPI env hash and pass it to Slurm's env
        $self->set($self->$mpi->env->%*) if $self->$mpi->has_env 
    }

}; 

sub write_resource ($self) {
    $self->printf("%s\n\n", $self->shell);

    for (qw(name queue select ntasks omp walltime stderr stdout ngpus account)) {
        my $has = "_has_$_";
        $self->printf("%s\n", $self->$_) if $self->$has;
    }

    return $self
}

sub run ($self) { 
    system 'sbatch', $self->script; 

    return $self; 
} 

__PACKAGE__->meta->make_immutable;

1
