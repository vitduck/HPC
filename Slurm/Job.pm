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
    isa     => Cpus_per_Task, 
    coerce  => 1, 
    trigger => sub ($self, @) { 
        my $omp_num_threads = (split /=/, $self->omp)[-1]; 

        # pass OMP_NUM_THREADS to MPI 
        $self->mvapich2->omp($omp_num_threads) if $self->_has_mvapich2; 
        $self->openmpi->omp($omp_num_threads)  if $self->_has_openmpi; 

        # pass OMP_NUN_THREADS to Gromacs cmd
        $self->gromacs->ntomp($omp_num_threads) if $self->_has_gromacs
    } 
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

# pass OMP_NUM_THREAD to mvapich2 env list
has '+mvapich2' => ( 
    trigger => sub ($self, @) { 
        my $omp_num_threads = (split /=/, $self->omp)[-1]; 

        $self->_add_plugin('mvapich2'); 
        
        # pass OMP_NUN_THREADS to MPI
        $self->mvapich2->omp($omp_num_threads) if $self->_has_omp; 
    } 
); 

# pass number of thread to gromacs cmd
has '+gromacs' => ( 
    trigger => sub ( $self, @ ) { 
        my $omp_num_threads = (split /=/, $self->omp)[-1]; 

        $self->account('gromacs'); 
        $self->_add_plugin('gromacs'); 

        # pass OMP_NUN_THREADS to Gromacs cmd
        $self->gromacs->ntomp($omp_num_threads) if $self->_has_omp; 
    }
);  

# pass number of gpu to lammps/gpu package
has '+lammps' => ( 
    trigger => sub ( $self, @ ) { 
        my $omp_num_threads = (split /=/, $self->omp)[-1]; 

        $self->account('lammps');
        $self->_add_plugin('lammps');

        # pass OMP_NUN_THREADS to Lammps cmd
        $self->lammps->gpu->ngpu($omp_num_threads) if $self->lammps->_has_gpu
    }
);  

# pass MPI environments to slurm's env
before 'write' => sub ($self, @) { 
    if    ( $self->_has_impi     && $self->impi->has_env     ) { $self->set_env($self->impi->env->%*)     } 
    elsif ( $self->_has_openmpi  && $self->openmpi->has_env  ) { $self->set_env($self->openmpi->env->%*)  } 
    elsif ( $self->_has_mvapich2 && $self->mvapich2->has_env ) { $self->set_env($self->mvapich2->env->%*) }
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
