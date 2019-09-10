package HPC::PBS::App;  

use Moose::Role; 

use HPC::App::Aps; 
use HPC::App::Numa; 
use HPC::App::Lammps; 
use HPC::App::Gromacs; 
use HPC::PBS::Types::App qw(Aps Numa Gromacs Lammps); 

has 'aps' => ( 
    is       => 'rw', 
    isa      => Aps,
    coerce   => 1, 
    traits   => ['Chained'],
    init_arg => undef, 
    handles  => { aps_cmd => 'cmd' }
); 

has 'numa' => (
    is       => 'rw', 
    isa      => Numa,
    traits   => ['Chained'],
    coerce   => 1, 
    init_arg => undef, 
    handles  => { numa_cmd => 'cmd' }
); 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    traits    => ['Chained'],
    coerce    => 1, 
    init_arg  => undef,
    handles  => { lammps_cmd => 'cmd' }
); 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    traits    => ['Chained'],
    coerce    => 1, 
    init_arg  => undef,
    handles  => { gromacs_cmd => 'cmd' }
); 

1
