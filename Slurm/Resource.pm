package HPC::Slurm::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int);
use HPC::Types::Sched::Slurm qw(Tasks Ngpus Mem); 
use feature 'signatures';
no warnings 'experimental::signatures';

has 'ntasks' => ( 
    is        => 'rw', 
    isa       => Tasks,
    init_arg  => undef,
    traits    => ['Chained'],
    predicate => '_has_ntasks', 
    clearer   => '_clear_ntasks', 
    lazy      => 1, 
    coerce    => 1, 
    default   => sub ($self) { 
        my $select   = $1 if $self->select   =~ /(\d+)$/; 
        my $mpiprocs = $1 if $self->mpiprocs =~ /(\d+)$/; 
        
        return $select*$mpiprocs;
    } 
); 

has 'ngpus' => ( 
    is        => 'rw', 
    isa       => Ngpus,
    traits    => ['Chained'],
    predicate => '_has_ngpus', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 1, 
); 

has 'mem' => ( 
    is        => 'rw', 
    isa       => Mem, 
    predicate => '_has_mem', 
    traits    => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    default   => '96G'
); 

1
