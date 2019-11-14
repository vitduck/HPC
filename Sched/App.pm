package HPC::Sched::App;  

use Moose::Role; 
use HPC::Plugin::Aps; 
use HPC::Plugin::Numa; 
use HPC::Plugin::Qe; 
use HPC::Plugin::Lammps; 
use HPC::Plugin::Gromacs; 
use HPC::Plugin::Tensorflow; 
use HPC::Sched::Types::App qw(Aps Numa Qe Gromacs Lammps Tensorflow); 
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
    trigger  => sub ($self, @) { $self->queue('flat') } 
); 

has 'qe' => (
    is       => 'rw', 
    isa      => Qe,
    init_arg => undef, 
    traits   => ['Chained'],
    coerce   => 1, 
    trigger  => sub ($self, $app, @) { $self->account('qe') }
); 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    init_arg  => undef,
    traits    => ['Chained'],
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { $self->account('lammps') }
); 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    init_arg  => undef, 
    traits    => ['Chained'],
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { $self->account('gromacs') }
); 

has 'tensorflow' => (
    is        => 'rw', 
    isa       => Tensorflow,
    init_arg  => undef, 
    traits    => ['Chained'],
    coerce    => 1,  
    trigger  => sub ($self, $app, @) { $self->account('tf') }
); 

1
