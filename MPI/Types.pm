package HPC::MPI::Types; 

use IO::File; 
use MooseX::Types -declare => [qw/MPI/];  
use MooseX::Types::Moose qw/Str Int Object/;  

subtype MPI, 
    as Object; 
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
