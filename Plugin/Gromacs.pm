package HPC::Plugin::Gromacs; 

use Moose::Role; 
use HPC::Types::Sched::Plugin 'Gromacs'; 
use HPC::App::Gromacs; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    init_arg  => undef, 
    traits    => ['Chained'],
    coerce    => 1, 
    trigger  => sub ($self, $app, @) { $self->account('gromacs') }
); 

1
