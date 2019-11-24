package HPC::Types::Mpi::Openmpi; 

use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(Report Map Bind)]; 

subtype Report, as Str, where { /-report-bindings/ }; 
subtype Bind,   as Str, where { /-bind-to/         }; 
subtype Map,    as Str, where { /-map-by/          }; 

coerce Report, from Int, via { '-report-bindings'    }; 
coerce Bind,   from Str, via { "-bind-to $_"         }; 
coerce Map,    from Str, via { "-map-by $_"          }; 

1
