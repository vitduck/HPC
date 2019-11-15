package HPC::Sched::Plugin; 

use Moose::Role; 

with qw(
    HPC::Plugin::Mpi
    HPC::Plugin::Aps
    HPC::Plugin::Numa
    HPC::Plugin::Qe HPC::Plugin::Vasp
    HPC::Plugin::Lammps HPC::Plugin::Gromacs
    HPC::Plugin::Tensorflow ); 

1 
