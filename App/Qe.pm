package HPC::App::Qe; 

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::XSAccessor; 
use namespace::autoclean; 

use HPC::App::Types::Qe qw(Input Output Image Pools Band Task Diag); 

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

has image => (
    is        => 'rw',
    isa       => Image,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_image', 
    lazy      => 1, 
    default   => 1 
);   

has image => (
    is        => 'rw',
    isa       => Image,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_image', 
    lazy      => 1, 
    default   => 1 
);   

has pools => (
    is        => 'rw',
    isa       => Pools, 
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_pools', 
    lazy      => 1, 
    default   => 1 
);   

has band => (
    is        => 'rw',
    isa       => Band,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_band', 
    lazy      => 1, 
    default   => 1 
);   

has task => (
    is        => 'rw',
    isa       => Task,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_task', 
    lazy      => 1, 
    default   => 1 
);   

has diag => (
    is        => 'rw',
    isa       => Diag,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_diag', 
    lazy      => 1, 
    default   => 1 
);   


sub _get_opts { 
    return qw(image pools band task diag inp out); 
}

__PACKAGE__->meta->make_immutable;

1
