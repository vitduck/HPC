package HPC::App::Nccl; 

use Moose; 
use MooseX::Attribute::Chained; 
use Moose::Util::TypeConstraints; 

use namespace::autoclean;
use experimental 'signatures'; 

has 'debug' => (
    is        => 'rw', 
    isa       => enum([qw(VERSION WARN INFO)]), 
    predicate => '_has_debug',
    traits    => ['Chained'], 
    default   => 'VERSION'
); 

has 'p2p' => (
    is        => 'rw', 
    isa       => enum([qw(0 1)]),
    predicate => '_has_p2p',
    traits    => ['Chained'], 
    default   => '1'
); 

has 'rdma' => (
    is        => 'rw', 
    isa       => enum([qw(0 1 2 3 4 5)]),
    predicate => '_has_rdma',
    traits    => ['Chained'], 
    default   => 2,
    trigger   => sub ($self, $rdma, @) { 
        $self->threads(0) if $rdma > 0
    } 
); 

has 'threads' => (
    is        => 'rw', 
    isa       => enum([qw(0 1)]),
    predicate => '_has_threads',
    traits    => ['Chained'], 
    default   => 1,
); 

__PACKAGE__->meta->make_immutable;

1
