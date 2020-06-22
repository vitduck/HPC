package HPC::Types::App::Gromacs;  

use MooseX::Types::Moose qw/Str Int/; 
use MooseX::Types -declare => [ 
    qw( Verbose Tpr Deffnm Log Confout 
        Nt Ntmpi Ntomp Npme
        Tunepme Dlb DDorder 
        Nsteps Resetstep Resethway
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
    via { $_ ? '-v': '' }; 

subtype Deffnm, 
    as Str, 
    where { /^\-deffnm/ }; 
coerce Deffnm,     
    from Str, 
    via { '-deffnm '.$_ }; 

subtype Confout,   
    as Str, 
    where { /^\-noconfout|^$/ };  
coerce Confout,    
    from Int, 
    via { $_ ? '' : '-noconfout' }; 

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

subtype Npme,      
    as Str, 
    where { /^\-npme/ };  
coerce Npme,       
    from Int, 
    via { '-npme '.$_ }; 

subtype Tunepme,   
    as Str, 
    where { /^\-notunepme|^$/ }; 
coerce Tunepme,    
    from Int, 
    via { $_ ? '' : '-notunepme' }; 

subtype Dlb,       
    as Str,
    where { /^\-dlb/ };  
coerce Dlb,        
    from Str, 
    via { '-dlb '.$_ }; 

subtype DDorder,   
    as Str, 
    where { /^\-ddorder/ };  
coerce DDorder,    
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
    as Str, 
    where { /^\-resethway|^$/ };  
coerce Resethway,  
    from Int, 
    via { $_ ? '-resethway' : '' }; 

1
