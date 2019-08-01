package HPC::MPI::Types; 

use IO::File; 
use MooseX::Types -declare => [qw(
    IMPI OPENMPI MVAPICH2
    Module_IMPI Module_OPENMPI Module_MVAPICH2)];  

use MooseX::Types::Moose qw/Undef Str Int Object/;  

class_type IMPI,     { class => 'HPC::MPI::IMPI'     }; 
class_type OPENMPI,  { class => 'HPC::MPI::OPENMPI'  }; 
class_type MVAPICH2, { class => 'HPC::MPI::MVAPICH2' }; 

coerce IMPI,
    from Str, 
    via { 
        my ($module, $version) = split /\//, $_;

        return HPC::MPI::IMPI->new(
            module  => $module, 
            version => $version
        )
    }; 

coerce OPENMPI,
    from Str, 
    via { 
        my ($module, $version) = split /\//, $_;

        return HPC::MPI::OPENMPI->new(
            module  => $module, 
            version => $version
        )
    }; 

coerce MVAPICH2, 
    from Str, 
    via { 
        my ($module, $version) = split /\//, $_;

        return HPC::MPI::MVAPICH2->new(
            module  => $module, 
            version => $version
        )
    }; 

1
