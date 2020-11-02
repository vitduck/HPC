package HPC::Sched::Plugin; 

use Moose::Role; 
use MooseX::Types::Moose 'ArrayRef'; 

use namespace::autoclean;
use experimental 'signatures';  

with qw(
    HPC::Plugin::Mpi
    HPC::Plugin::Aps
    HPC::Plugin::Numa
    HPC::Plugin::Qe HPC::Plugin::Vasp
    HPC::Plugin::Lammps HPC::Plugin::Gromacs
    HPC::Plugin::Tensorflow HPC::Plugin::Nccl
); 

has 'plugin' => ( 
    is       => 'rw', 
    isa      => ArrayRef, 
    init_arg => undef,
    traits   => [qw(Array Chained)], 
    lazy     => 1, 
    default  => sub {[]},  
    handles  => { 
        _add_plugin => 'push', 
        list_plugin => 'elements'
    } 
);

1 
