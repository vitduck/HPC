package HPC::Types::Profile::Aps;  

use MooseX::Types::Moose qw(Str Int);  
use MooseX::Types -declare => [qw(Type Level Report)];  

subtype Type,   
    as Str, 
    where { /APS_IMBALANCE_TYPE/ }; 
coerce Type,   
    from Int, 
    via { "export APS_IMBALANCE_TYPE=$_" };  

subtype Level,  
    as Str, 
    where { /MPS_STAT_LEVEL/ }; 
coerce Level,  
    from Int, 
    via { "export MPS_STAT_LEVEL=$_" }; 

subtype Report, 
    as Str, 
    where { /^\-\-report/ }; 
coerce Report, 
    from Str, 
    via { "--report=$_" }; 

1
