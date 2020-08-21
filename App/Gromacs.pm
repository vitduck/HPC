package HPC::App::Gromacs; 

use Moose; 
use MooseX::Attribute::Chained;
use MooseX::StrictConstructor;
use MooseX::Types::Moose 'Str';
use MooseX::XSAccessor; 


use namespace::autoclean; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd
    HPC::App::Gromacs::Input
    HPC::App::Gromacs::Output
    HPC::App::Gromacs::Pme
    HPC::App::Gromacs::Nb
    HPC::App::Gromacs::Thread
    HPC::App::Gromacs::Prof ); 

has 'mode' => (  
    is        => 'rw', 
    isa       => Str,
    traits    => ['Chained'], 
    predicate => '_has_mode',
    default   => 'mdrun'
); 

sub _opts { 
    return qw( 
        mode
        tpr deffnm log nsteps 
        dlb ddorder npme nb tunepme
        confout resetstep resethway 
        pin nt ntmpi ntomp 
        verbose ) 
}

1
