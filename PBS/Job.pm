package HPC::PBS::Job; 

use Moose;
use Moose::Util::TypeConstraints; 
use namespace::autoclean;

use HPC::MPI::IMPI; 
use HPC::MPI::OPENMPI; 
use HPC::MPI::MVAPICH2; 

with 'MooseX::Traits'; 
with 'HPC::Env::Module'; 
with 'HPC::MPI::Types'; 
with 'HPC::PBS::Debug';  
with 'HPC::PBS::IO';  
with 'HPC::PBS::Qsub'; 
with 'HPC::PBS::MPI'=> { mpi => 'impi' };  
with 'HPC::PBS::MPI'=> { mpi => 'openmpi' };  
with 'HPC::PBS::MPI'=> { mpi => 'mvapich2' };  

has 'cmd' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => 'ArrayRef[Str]',
    lazy    => 1, 
    default => sub {['cd $PBS_O_WORKDIR']},
    handles => {
         add_cmd => 'push',
        list_cmd => 'elements', 
    }, 
    clearer => 'new_cmd', 
);

sub BUILD {
    my $self = shift; 

    $self->initialize; 
    $self->cmd; 
} 

sub qsub {
    my $self = shift; 

    system 'qsub', $self->pbs; 
} 

sub _write_pbs { 
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
    $self->printf("#PBS -e %s\n", $self->name) if $self->stderr;  
    $self->printf("#PBS -o %s\n", $self->name) if $self->stdout; 

    # resource 
    $self->printf(
        "#PBS -l select=%d:ncpus=%d:mpiprocs=%d:ompthreads=%d\n", 
        $self->select, 
        $self->ncpus, 
        $self->mpiprocs,
        $self->ompthreads
    ); 

    $self->printf("#PBS -l walltime=%s\n", $self->walltime); 
    $self->printf("\n"); 

    # command 
    for my $cmd ($self->list_cmd) { 
        $self->printf("$cmd\n"); 
    } 
} 

__PACKAGE__->meta->make_immutable;

1; 
