package HPC::App::Qe; 

use Moose; 
use MooseX::Aliases;
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::XSAccessor; 

use HPC::Types::App::Qe qw(Input Output Image Pools Band Task Diag);

use namespace::autoclean;
use experimental 'signatures'; 

with qw(HPC::Debug::Dump HPC::Plugin::Cmd); 

has '+bin' => ( 
    lazy      => 1, 
    default   => 'pw.x'
); 

has inp => (
    alias     => 'in',
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

has nimage => (
    alias     => 'ni', 
    is        => 'rw',
    isa       => Image,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nimage', 
    lazy      => 1, 
    default   => 1 
);   

has npools => (
    alias     => 'nk', 
    is        => 'rw',
    isa       => Pools, 
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_npools', 
    default   => 1  
);   

has nband => (
    alias     => 'nb', 
    is        => 'rw',
    isa       => Band,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_nband', 
    lazy      => 1, 
    default   => 1 
);

has ntg => (
    alias     => 'nt', 
    is        => 'rw',
    isa       => Task,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_ntg', 
    lazy      => 1, 
    default   => 1
);

has ndiag => (
    alias     => 'nd', 
    is        => 'rw',
    isa       => Diag,
    traits    => ['Chained'],
    coerce    => 1,
    predicate => '_has_ndiag', 
    lazy      => 1, 
    default   => 1
);

sub _opts {
    return qw(inp nimage npools nband ntg ndiag out)
}

__PACKAGE__->meta->make_immutable;

1
