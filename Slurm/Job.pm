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

has '+submit_cmd' => (
    default => 'sbatch'
); 

has '+name' => ( 
    isa     => Name, 
    coerce  => 1, 
); 

has '+account' => ( 
    isa     => Comment,
    coerce  => 1, 
); 

has '+queue' => ( 
    isa     => Partition, 
    coerce  => 1, 
    default => 'normal'
); 

has '+select' => ( 
    isa     => Nodes,
    coerce  => 1, 
    trigger => sub ($self, @) { 
        $self->_clear_ntasks; 
    }
);

has '+mpiprocs' => ( 
    isa    => Tasks_per_Node, 
    coerce => 1, 
    trigger => sub ($self, @) { 
        $self->_clear_ntasks; 
    }
);

has '+omp' => ( 
    isa    => Cpus_per_Task, 
    coerce => 1
); 

has '+stderr' => ( 
    isa     => Error, 
    coerce  => 1, 
    default => '%j.stderr'
); 

has '+stdout' => ( 
    isa     => Output, 
    coerce  => 1, 
    default => '%j.stdout'
); 

has '+walltime' => ( 
    isa     => Time, 
    coerce  => 1, 
    default => '24:00:00'
); 

has '+mvapich2' => ( 
    trigger => sub ($self, @) { 
        $self->_add_plugin('mvapich2'); 

        if ( $self->_has_omp ) {
            $self->mvapich2->omp((split /=/, $self->omp)[-1])
        }
    } 
); 

before 'write' => sub ($self, @) { 
    my ($mpi, %env);  

    if ($self->mpi) { 
        $mpi = $self->mpi; 

        # deref MPI env hash and pass it to Slurm's env
        $self->set($self->$mpi->env->%*) if $self->$mpi->has_env 
    }

}; 

sub write_resource ($self) {
    $self->ntasks; 
    $self->printf("%s\n\n", $self->shell);

    for (qw(name queue select mpiprocs omp mem ngpus stderr stdout walltime account)) {
        my $has = "_has_$_";
        $self->printf("%s\n", $self->$_) if $self->$has;
    }

    return $self
}

__PACKAGE__->meta->make_immutable;

1
