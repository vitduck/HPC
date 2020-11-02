package HPC::Slurm::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int);
use HPC::Types::Sched::Slurm qw(Nodelist Exclude Tasks Mem); 

use experimental 'signatures';

has nodelist => ( 
    is        => 'rw', 
    isa       => Nodelist,
    traits    => ['Chained'],
    predicate => '_has_nodelist', 
    clearer   => '_clear_nodelist', 
    coerce    => 1
); 

has exclude => ( 
    is        => 'rw', 
    isa       => Exclude,
    traits    => ['Chained'],
    predicate => '_has_exclude', 
    clearer   => '_clear_exclude', 
    coerce    => 1
); 

has ntasks => ( 
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

has mem => ( 
    is        => 'rw', 
    isa       => Mem, 
    predicate => '_has_mem', 
    traits    => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    default   => 0
); 

1
