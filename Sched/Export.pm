package HPC::Sched::Export; 

use Moose::Role;
use feature 'signatures';
no warnings 'experimental::signatures';

has 'export' => (
    is       => 'rw', 
    isa      => Export,
    init_arg => undef,
    traits   => ['Chained'],
    #lazy     => 1, 
    #default  => 'knl/intel', 
    #trigger  => sub ($self, $env, @) { 
        #my ($cpu, $compiler) = split /\//, $env;  

        #$self->purge; 

        #$self->load(
            #$preset{$cpu}, 
            #$preset{$compiler}->@*
        #); 
    #} 
); 

1 
