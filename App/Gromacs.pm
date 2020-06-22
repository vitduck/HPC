package HPC::App::Gromacs; 

use Moose; 
use MooseX::Attribute::Chained;
use MooseX::StrictConstructor;
use MooseX::XSAccessor; 

use namespace::autoclean; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd
    HPC::App::Gromacs::Input
    HPC::App::Gromacs::Output
    HPC::App::Gromacs::Pme
    HPC::App::Gromacs::Thread
    HPC::App::Gromacs::Prof ); 

sub _opts { 
    return sort qw( 
        tpr 
        deffnm log confout verbose 
        tunepme dlb ddorder npme
        nsteps resetstep resethway 
        nt ntmpi ntomp ) 
}

1
