package HPC::Plugin::Tensorflow::Kmp; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str Int); 

has mkl => ( 
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_mkl',
    default   => 'true'
); 

has kmp_affinity => (
    is        => 'rw',
    isa       => Str,
    traits    => ['Chained'],
    predicate => '_has_kmp_affinity',
    default   => 'granularity=fine,compact'
);

has kmp_blocktime => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_kmp_blocktime',
    default   => 0
);

has kmp_settings => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_kmp_settings', 
    default   => 0
);   

1
