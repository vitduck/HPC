package HPC::Types::Sched::Mpi; 

use MooseX::Types::Moose qw(Str ArrayRef); 
use MooseX::Types -declare => [qw(Impi Openmpi Mvapich2)]; 

class_type Impi,     
    { class => 'HPC::Mpi::Impi' }; 
coerce Impi,     
    from Str,      
        via { HPC::Mpi::Impi->new(module => $_) },
    from ArrayRef, 
        via { HPC::Mpi::Impi->new(module => $_->[0], $_->@[1..$_->$#*]) };  

class_type Openmpi,  
    { class => 'HPC::Mpi::Openmpi' }; 
coerce Openmpi,
    from Str,      
        via { HPC::Mpi::Openmpi->new(module => $_) },
    from ArrayRef, 
        via { HPC::Mpi::Openmpi->new(module => $_->[0], $_->@[1..$_->$#*]) }; 

class_type Mvapich2, 
    { class => 'HPC::Mpi::Mvapich2' }; 
coerce Mvapich2, 
    from Str,      
        via { HPC::Mpi::Mvapich2->new(module => $_) },
    from ArrayRef, 
        via { HPC::Mpi::Mvapich2->new(module => $_->[0], $_->@[1..$_->$#*]) }; 

1; 
