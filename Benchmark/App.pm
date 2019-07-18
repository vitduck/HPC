package HPC::Benchmark::App; 

use MooseX::Role::Parameterized; 

parameter app => ( 
    is       => 'ro', 
    isa      => 'Str', 
    required => 1
); 

role { 
    my $app   = shift->app; 
    my $class = 'HPC::Benchmark::'.uc($app); 

    has $app => ( 
        is       => 'rw', 
        isa      => $class,
        lazy     => 1, 
        default  => sub { $class->new }, 
    ); 
}; 

1
