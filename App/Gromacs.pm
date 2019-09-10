package HPC::App::Gromacs; 

use Moose; 
use MooseX::XSAccessor; 
use namespace::autoclean; 

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data 
    HPC::App::Gromacs::Input
    HPC::App::Gromacs::Output
    HPC::App::Gromacs::Pme
    HPC::App::Gromacs::Thread
    HPC::App::Gromacs::Prof
); 

sub _get_opts { 
    return sort qw( 
        tpr 
        deffnm log confout verbose 
        tunepme dlb ddorder 
        nsteps resetstep resethway 
        nt ntmpi ntomp
    ); 
}

1
