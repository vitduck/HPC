package HPC::App::Lammps::Package; 

use Moose::Role; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(Int Str); 

has 'name' => ( 
    is        => 'rw', 
    isa       => Str, 
    traits    => ['Chained'],
    init_arg  => undef, 
    predicate => '_has_name'
); 

has 'arg' => ( 
    is        => 'rw', 
    isa       => Int, 
    traits    => ['Chained'],
    init_arg  => undef, 
    predicate => '_has_arg', 
    lazy      => 0, 
    default   => 0,
); 

sub pkg_opt {
    my $self = shift; 
    my @opts = (); 

    push @opts, $self->name; 
    push @opts, $self->arg if $self->_has_arg; 

    for (sort grep !/(name|arg)/, $self->meta->get_attribute_list) { 
        my $has = "_has_$_"; 
    
        push @opts, $_, $self->$_ if $self->$has
    }

    return [@opts]
} 

1
