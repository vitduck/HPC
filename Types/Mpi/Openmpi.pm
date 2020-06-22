package HPC::Types::Mpi::Openmpi; 

use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Report Map Bind)]; 

subtype Report, 
    as Str, 
    where { /--report-bindings/ }; 
coerce Report, 
    from Int, 
    via { '--report-bindings' }; 

subtype Bind, 
    as Str, 
    where { /--bind-to/ }; 
coerce Bind, 
    from Str, 
    via  { "--bind-to $_" }; 

subtype Map,    
    as Str, 
    where { /--map-by/ }; 
coerce Map, 
    from Str, 
    via  { "--map-by $_" }; 

1
