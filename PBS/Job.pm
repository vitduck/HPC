package HPC::PBS::Job; 

use Moose;
use Moose::Util::TypeConstraints; 
use namespace::autoclean;

with 'HPC::Env::Module'; 
with 'HPC::PBS::Qsub'; 
with 'HPC::MPI::Types'; 
with 'HPC::MPI::Parameterized' => { mpi => 'impi'     };  
with 'HPC::MPI::Parameterized' => { mpi => 'openmpi'  };  
with 'HPC::MPI::Parameterized' => { mpi => 'mvapich2' };  

has '+impi' => ( 
    handles => [qw(enable_debug)]
); 

has '+openmpi' => ( 
    handles => [qw(affinity)]
); 


sub BUILD {  
    my $self = shift; 

    $self->initialize; 
} 

__PACKAGE__->meta->make_immutable;

1; 
