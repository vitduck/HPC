package HPC::Mpi::Psm2; 

use Moose::Role; 
use MooseX::Types::Moose 'Bool'; 
use feature 'signatures';
no warnings 'experimental::signatures';

has 'kassist' => ( 
    is       => 'rw', 
    isa      =>  Bool, 
    init_arg => undef,
    trigger  => sub ($self, $mode, @) { 
        $self->set_env(
            PSM2_KASSIST_MODE => 'none', 
        ); 
    } 
); 

1
