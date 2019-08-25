package HPC::App::GROMACS::Types; 

use MooseX::Types -declare => [qw(Tpr Log Deffnm Verbose Tunepme Dlb Nsteps Resetstep Resethway Confout)]; 
use MooseX::Types::Moose qw/Str Int/; 

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

subtype Deffnm, 
    as Str, 
    where { /^\-deffnm/ }; 

coerce Deffnm, 
    from Str, 
    via { '-deffnm '.$_ }; 

subtype Verbose, 
    as Str, 
    where { $_ =~ /^\-v/ or $_ eq '' }; 

coerce Verbose, 
    from Int, 
    via { $_ ? '-v': '' }; 

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
    where { $_ =~ /^\-resethway/ or $_ eq '' };  

coerce Resethway, 
    from Int, 
    via { $_ ? '-resethway' : '' }; 

subtype Confout,
    as Str, 
    where { /^\-confout/ };  

coerce Confout, 
    from Int, 
    via { $_ ? '-confout' : '-noconfout' }; 

1
