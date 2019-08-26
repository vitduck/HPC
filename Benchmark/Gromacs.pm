package HPC::Benchmark::Gromacs; 

use Moose; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

with qw(
    HPC::Debug::Data 
    HPC::Benchmark::Base 
    HPC::App::Gromacs::Input
    HPC::App::Gromacs::Output
    HPC::App::Gromacs::Pme
    HPC::App::Gromacs::Thread
    HPC::App::Gromacs::Prof
    HPC::App::Gromacs::Cmd); 

__PACKAGE__->meta->make_immutable;

1
