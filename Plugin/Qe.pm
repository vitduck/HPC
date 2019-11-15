package HPC::Plugin::Qe;  

use Moose::Role; 
use HPC::Types::Sched::Plugin 'Qe'; 
use HPC::App::Qe; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has 'qe' => (
    is       => 'rw', 
    isa      => Qe,
    init_arg => undef, 
    traits   => ['Chained'],
    coerce   => 1, 
    trigger  => sub ($self, $app, @) { $self->account('qe') }
); 

1
