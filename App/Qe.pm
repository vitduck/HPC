package HPC::App::Qe; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::XSAccessor; 
use MooseX::StrictConstructor; 
use HPC::App::Types::Qe qw(Input Output Image Pools Band Task Diag);
use namespace::autoclean;

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data 
);

has inp => (
    is        => 'rw',
    isa       => Input,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_inp',
);

has out => (
    is        => 'rw',
    isa       => Output,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_out',
);

has ni => (
    is        => 'rw',
    isa       => Image,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_ni', 
    lazy      => 1, 
    default   => 1 
);   

has nk => (
    is        => 'rw',
    isa       => Pools, 
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nk', 
    default   => 1 
);   

has nb => (
    is        => 'rw',
    isa       => Band,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nb', 
    lazy      => 1, 
    default   => 1 
);

has nt => (
    is        => 'rw',
    isa       => Task,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nt', 
    lazy      => 1, 
    default   => 1 
);

has nd => (
    is        => 'rw',
    isa       => Diag,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nd', 
    lazy      => 1, 
    default   => 1 
);

sub _get_opts { 
    return qw(ni nk nb nt nd inp out); 
}

__PACKAGE__->meta->make_immutable;

1
