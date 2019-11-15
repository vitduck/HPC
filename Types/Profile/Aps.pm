package HPC::Types::Profile::Aps;  

use MooseX::Types::Moose qw(Str Int);  
use MooseX::Types -declare => [qw(Type Level Report)];  

subtype Type,   as Str, where { /APS_IMBALANCE_TYPE/ }; 
subtype Level,  as Str, where { /MPS_STAT_LEVEL/     }; 
subtype Report, as Str, where { /^\-\-report/        }; 

coerce  Type,   from Int, via { "export APS_IMBALANCE_TYPE=$_" };  
coerce  Level,  from Int, via { "export MPS_STAT_LEVEL=$_"     }; 
coerce  Report, from Str, via { "--report=$_"                  }; 

1
