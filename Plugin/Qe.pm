package HPC::Plugin::Qe; 

use Moose; 
use MooseX::Aliases;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use HPC::Plugin::Types::Qe qw(Input Output Image Pools Band Task Diag);
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
    alias     => 'in',
);

has out => (
    is        => 'rw',
    isa       => Output,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_out',
);

has nimage => (
    is        => 'rw',
    isa       => Image,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nimage', 
    lazy      => 1, 
    default   => 1, 
    alias     => 'ni'
);   

has npools => (
    is        => 'rw',
    isa       => Pools, 
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_npools', 
    default   => 1,  
    alias     => 'nk'
);   

has nband => (
    is        => 'rw',
    isa       => Band,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nband', 
    lazy      => 1, 
    default   => 1, 
    alias     => 'nb'
);

has ntg => (
    is        => 'rw',
    isa       => Task,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_ntg', 
    lazy      => 1, 
    default   => 1,
    alias     => 'nt'
);

has ndiag => (
    is        => 'rw',
    isa       => Diag,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_ndiag', 
    lazy      => 1, 
    default   => 1, 
    alias     => 'nd'
);

sub _get_opts {
    return qw(inp nimage npools nband ntg ndiag out)
}

__PACKAGE__->meta->make_immutable;

1
