package HPC::PBS::IO; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 
use HPC::PBS::Types::IO 'FH'; 

use feature 'signatures';  
no warnings 'experimental::signatures'; 

has 'script' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef, 
    traits   => [ 'Chained' ],
    lazy     => 1, 
    default  => 'run.sh', 
    trigger  => sub ($self, $pbs, @) { $self->fh($pbs) } 
); 

has 'fh' => ( 
    is       => 'rw', 
    isa      => FH, 
    init_arg => undef, 
    traits   => ['Chained'],
    coerce   => 1, 
    lazy     => 1, 
    default  => 'run.sh',
    handles  => [qw(print printf close)]
); 

1
