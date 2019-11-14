package HPC::Plugin::Gromacs; 

use Moose; 
use MooseX::XSAccessor; 
use namespace::autoclean; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd
    HPC::Plugin::Gromacs::Input
    HPC::Plugin::Gromacs::Output
    HPC::Plugin::Gromacs::Pme
    HPC::Plugin::Gromacs::Thread
    HPC::Plugin::Gromacs::Prof ); 

sub _get_opts { 
    return sort qw( 
        tpr 
        deffnm log confout verbose 
        tunepme dlb ddorder npme
        nsteps resetstep resethway 
        nt ntmpi ntomp ) 
}

1
