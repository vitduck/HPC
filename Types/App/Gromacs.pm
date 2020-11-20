package HPC::Types::App::Gromacs;  

use MooseX::Types::Moose qw/Undef Str Int/; 
use MooseX::Types -declare => [ 
    qw( Verbose Tpr Deffnm Log Confout 
        Nt Ntmpi Ntomp Npme Nb Pin
        Tunepme Dlb Ddorder 
        Nsteps Resetstep Resethway
        Nb Bonded Pme Update
    ) 
]; 

subtype Tpr,       
    as Str, 
    where { /^\-s/ };
coerce Tpr,        
    from Str, 
    via { '-s '.$_ };

subtype Log, 
    as Str, 
    where { /^\-g/ };
coerce Log, 
    from Str, 
    via { '-g '.$_ };

subtype Verbose,   
    as Str, 
    where { /^\-v|^$/ }; 

coerce Verbose,    
    from Int, 
    via { $_ ? '-v': '-nov' }; 

subtype Deffnm, 
    as Str, 
    where { /^\-deffnm/ }; 
coerce Deffnm,     
    from Str, 
    via { '-deffnm '.$_ }; 

subtype Confout,   
    as Str, 
    where { /^\-noconfout/ };  
coerce Confout,    
    from Int, 
    via { '-noconfout' }; 

subtype Nt,        
    as Str, 
    where { /^\-nt/ };  
coerce Nt,         
    from Int, 
    via { '-nt '.$_ }; 

subtype Ntmpi,     
    as Str, 
    where { /^\-ntmpi/ };  
coerce Ntmpi,      
    from Int, 
    via { '-ntmpi '.$_ }; 

subtype Ntomp,     
    as Str, 
    where { /^\-ntomp/ };  
coerce Ntomp,      
    from Int, 
    via { '-ntomp '.$_ }; 

subtype Pin,      
    as Str, 
    where { /^\-pin/ };  
coerce Pin,       
    from Int, 
    via { $_ ? '-pin on': '-pin off' }; 

subtype Npme,      
    as Str, 
    where { /^\-npme/ };  
coerce Npme,       
    from Int, 
    via { '-npme '.$_ }; 

subtype Nb,      
    as Str, 
    where { /^\-nb/ };  
coerce Nb,       
    from Str, 
    via { '-nb '.$_ }; 

subtype Tunepme,   
    as Str, 
    where { /tunepme/ }; 
coerce Tunepme,    
    from Int, 
    via { $_ ? '-tunepme' : '-notunepme' }; 

subtype Dlb,       
    as Str,
    where { /^\-dlb/ };  
coerce Dlb,        
    from Str, 
    via { '-dlb '.$_ }; 

subtype Ddorder,   
    as Str, 
    where { /^\-ddorder/ };  
coerce Ddorder,    
    from Str, 
    via { '-ddorder '.$_ }; 

subtype Nsteps,    
    as Str, 
    where { /^\-nsteps/ };  
coerce Nsteps,     
    from Int, 
    via { '-nsteps '.$_ }; 

subtype Resetstep, 
    as Str, 
    where { /^\-resetstep/ };  
coerce Resetstep,  
    from Int, 
    via { '-resetstep '.$_ }; 

subtype Resethway, 
    as Str|Undef, 
    where { $_ eq '-resethway' or ! defined  };  
coerce Resethway,  
    from Int, 
    via { $_ ? '-resethway' : undef  };  


subtype Pme,   as Str, where { /^-/ };  
coerce  Pme, from Str, via   { "-pme $_" }; 

subtype Bonded,   as Str, where { /^-/ };  
coerce  Bonded, from Str, via  { "-bonded $_" }; 

subtype Update,   as Str, where { /^-/ };  
coerce  Update, from Str, via  { "-update $_" }; 

1
