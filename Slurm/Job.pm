package HPC::Slurm::Job;  

use Moose;
use MooseX::Aliases; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::XSAccessor; 

use HPC::Types::Sched::Slurm 'Option';

use namespace::autoclean;
use experimental 'signatures';

with qw(HPC::Sched::Job HPC::Slurm::Resource HPC::Slurm::Srun);  

has '+_option' => (
    isa      => Option,
    coerce   => 1,
);

has '+stderr' => ( 
    default => '%j.stderr'
); 

has '+stdout' => ( 
    default => '%j.stdout'
); 

after 'mvapich2' => sub {  
    my $self = shift; 

    $self->mvapich2->hostfile('$SLURM_JOB_NODELIST')->nprocs('$SLURM_NPROCS') if @_;  
}; 

sub _sched_options ($self) { 
    return  qw(app queue name select mpiprocs omp mem ngpus stderr stdout walltime nodelist exclude) 
}

__PACKAGE__->meta->make_immutable;

1
