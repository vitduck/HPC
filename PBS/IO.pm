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
    trigger  => sub ($self, @args) { $self->fh(shift @args) } 
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

sub write ($self, $file) { 
    $self->script($file)
         ->write_pbs_resource 
         ->write_pbs_module   
         ->write_pbs_cmd
         ->close; 
    
    return $self
} 

1; 
