package HPC::PBS::MPI; 

use Moose::Role; 

with 'HPC::MPI::Parameterized' => { mpi => 'crayimpi' };  
with 'HPC::MPI::Parameterized' => { mpi => 'impi'     };  
with 'HPC::MPI::Parameterized' => { mpi => 'openmpi'  };  
with 'HPC::MPI::Parameterized' => { mpi => 'mvapich2' };  

1 
