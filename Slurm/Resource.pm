package HPC::Slurm::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int);
use HPC::Types::Sched::Slurm qw(Tasks Ngpu); 
use feature 'signatures';
no warnings 'experimental::signatures';

has 'ntasks' => ( 
    is        => 'rw', 
    isa       => Tasks,
    init_arg  => undef,
    predicate => '_has_ntasks', 
    clearer   => '_clear_ntasks', 
    coerce    => 1, 
    default   => 1 
); 

has 'ngpus' => ( 
    is        => 'ro', 
    isa       => Ngpu,
    init_arg  => undef,
    predicate => '_has_ngpus', 
    coerce    => 1, 
    default   => 1 
); 

1
