package HPC::PBS::App;  

use Moose::Role; 

use HPC::App::Aps; 
use HPC::App::Numa; 
use HPC::App::Qe; 
use HPC::App::Lammps; 
use HPC::App::Gromacs; 
use HPC::App::Tensorflow; 
use HPC::PBS::Types::App qw(Aps Numa Qe Gromacs Lammps Tensorflow); 

use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'aps' => ( 
    is       => 'rw', 
    isa      => Aps,
    init_arg => undef, 
    coerce   => 1, 
    traits   => ['Chained'],
); 

has 'numa' => (
    is       => 'rw', 
    isa      => Numa,
    init_arg => undef,
    traits   => ['Chained'],
    coerce   => 1, 
); 

has 'qe' => (
    is       => 'rw', 
    isa      => Qe,
    init_arg => undef, 
    traits   => ['Chained'],
    coerce   => 1, 
    trigger  => sub ($self, $app, @) { 
        $self->account('qe')
    }
); 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    init_arg  => undef,
    traits    => ['Chained'],
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { 
        $self->account('lammps')
    }
); 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    init_arg  => undef, 
    traits    => ['Chained'],
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { 
        $self->account('gromacs')
    }
); 

has 'tensorflow' => (
    is        => 'rw', 
    isa       => Tensorflow,
    init_arg  => undef, 
    traits    => ['Chained'],
    coerce    => 1,  
    trigger  => sub ($self, $app, @) { 
        $self->account('tf')
    }

); 

1
