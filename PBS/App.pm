package HPC::PBS::App;  

use Moose::Role; 
use HPC::PBS::Types::App qw(Aps Numa Gromacs); 
use HPC::App::Aps; 
use HPC::App::Numa; 
use HPC::App::Gromacs; 

has 'aps' => ( 
    is       => 'rw', 
    isa      => Aps,
    init_arg => undef, 
    lazy     => 1,
    default  => sub { HPC::App::Aps->new }, 
    handles  => { 
        set_aps        => 'set_opts',
        set_aps_type   => 'set_type',
        set_aps_level  => 'set_level',
        set_aps_report => 'set_report', 
        aps_cmd        => 'cmd'
    } 
); 

has 'numa' => ( 
    is       => 'rw', 
    isa      => Numa,
    init_arg => undef, 
    lazy     => 1, 
    default  => sub {HPC::App::Numa->new}, 
    handles  => { 
        set_numa_membind   => 'set_membind',
        set_numa_preferred => 'set_preferred', 
        set_numa           => 'set_opts',
        numa_cmd           => 'cmd'
    }
); 

has 'gromacs' => (
    is       => 'rw', 
    isa       => Gromacs, 
    init_arg  => undef, 
    lazy      => 1,
    default   => sub { HPC::App::Gromacs->new }, 
    handles   => { 
        set_gromacs        => 'set_opts',
        set_gromacs_deffnm => 'set_deffnm',
        set_gromacs_ntmpi  => 'set_ntmpi',
        set_gromacs_bin    => 'set_bin',
            gromacs_cmd    => 'cmd'
    }
); 

1
