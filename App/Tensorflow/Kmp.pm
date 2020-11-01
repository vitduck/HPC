package HPC::App::Tensorflow::Kmp; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 

has mkl => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_mkl',
    lazy      => 1, 
    default   => 'true', 
); 

has kmp_affinity => (
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_kmp_affinity',
    lazy      => 1 , 
    default   => 'granularity=fine,compact'
);

has kmp_blocktime => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_kmp_blocktime',
    lazy      => 1, 
    default   => 0
);

has kmp_settings => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_kmp_settings', 
    lazy      => 1 , 
    default   => 0
);   

1
