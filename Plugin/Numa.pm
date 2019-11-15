package HPC::Plugin::Numa; 

use Moose::Role; 
use HPC::Types::Sched::Plugin 'Numa'; 
use HPC::Profile::Numa; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'numa' => (
    is       => 'rw', 
    isa      => Numa,
    init_arg => undef,
    traits   => ['Chained'],
    coerce   => 1, 
    trigger  => sub ($self, @) { $self->queue('flat') } 
); 

1
