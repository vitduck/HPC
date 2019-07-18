package HPC::PBS::App; 

use Moose::Role; 
use HPC::Benchmark::LAMMPS; 

with 'HPC::Benchmark::App' => { app => 'lammps' }; 

1
