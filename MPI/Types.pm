package HPC::MPI::Types; 

use IO::File; 
use MooseX::Types -declare => [qw/MPI IMPI OPENMPI MVAPICH2/];  
use MooseX::Types::Moose qw/Str Int Object/;  

class_type IMPI,     { class => 'HPC::MPI::IMPI'     }; 
class_type OPENMPI,  { class => 'HPC::MPI::OPENMPI'  }; 
class_type MVAPICH2, { class => 'HPC::MPI::MVAPICH2' }; 

subtype MPI, 
    as IMPI|OPENMPI|MVAPICH2;  

coerce  MPI, 
    from Str, 
    via {  
        my ($module, $version) = split /\//, $_; 

        $module = 'impi' if $module eq 'cray-impi'; 

        return ('HPC::MPI::'.uc($module))->new( 
            module  => $module, 
            version => $version
        ); 
    }; 

1
