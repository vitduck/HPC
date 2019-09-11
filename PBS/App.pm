package HPC::PBS::App;  

use Moose::Role; 

use HPC::App::Aps; 
use HPC::App::Numa; 
use HPC::App::Qe; 
use HPC::App::Lammps; 
use HPC::App::Gromacs; 
use HPC::PBS::Types::App qw(Aps Numa Qe Gromacs Lammps); 

has 'aps' => ( 
    is       => 'rw', 
    isa      => Aps,
    coerce   => 1, 
    traits   => ['Chained'],
    init_arg => undef, 
    writer   => 'load_aps',
    clearer  => 'unload_aps',
    handles  => { aps_cmd => 'cmd' }
); 

has 'numa' => (
    is       => 'rw', 
    isa      => Numa,
    traits   => ['Chained'],
    coerce   => 1, 
    init_arg => undef, 
    writer   => 'load_numa',
    clearer  => 'unload_numa', 
    handles  => { numa_cmd => 'cmd' }
); 

has 'qe' => (
    is       => 'rw', 
    isa      => Qe,
    traits   => ['Chained'],
    coerce   => 1, 
    init_arg => undef, 
    writer   => 'load_qe',
    clearer  => 'unload_qe',
    handles  => { qe_cmd => 'cmd' }
); 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    traits    => ['Chained'],
    coerce    => 1, 
    init_arg  => undef,
    writer    => 'load_lammps',
    clearer   => 'unload_lammps',
    handles   => { lammps_cmd => 'cmd' }
); 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    traits    => ['Chained'],
    coerce    => 1, 
    init_arg  => undef,
    writer    => 'load_gromacs',
    clearer   => 'unload_gromacs',
    handles   => { gromacs_cmd => 'cmd' }
); 

1
