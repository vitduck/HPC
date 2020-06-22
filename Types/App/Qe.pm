package HPC::Types::App::Qe; 

use MooseX::Types::Moose qw/Str Int/; 
use MooseX::Types -declare => [qw(Input Output Image Pools Band Task Diag)]; 

subtype Input,  
    as Str, 
    where { /^\-/  }; 
coerce Input,  
    from Str, 
    via { '-in ' .$_ };

subtype Output, 
    as Str, 
    where { /^>/ }; 
coerce Output, 
    from Str, 
    via { '> ' .$_ }; 

subtype Image,  
    as Str, 
    where { /^\-/ }; 
coerce Image,  
    from Int, 
    via { '-ni ' .$_ }; 

subtype Pools, 
    as Str, 
    where { /^\-/ }; 
coerce Pools,  
    from Int, 
    via { '-nk ' .$_ }; 

subtype Band, 
    as Str, 
    where { /^\-/ }; 
coerce Band, 
    from Int, 
    via { '-nb ' .$_ }; 

subtype Task, 
    as Str, 
    where { /^\-/ }; 
coerce Task,   
    from Int, 
    via { '-nt ' .$_ }; 

subtype Diag,   
    as Str, 
    where { /^\-/  }; 
coerce Diag, 
    from Int, 
    via { '-nd ' .$_ }; 

1
