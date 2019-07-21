package HPC::PBS::App; 

use Moose::Role; 
use HPC::App::LAMMPS; 

with 'HPC::App::Parameterized' => { app => 'lammps' }; 

1
