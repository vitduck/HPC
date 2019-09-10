package HPC::App::Lammps::Package; 

use Moose::Role; 
use MooseX::Types::Moose qw(Int Str); 

has 'name' => ( 
    is        => 'rw', 
    isa       => Str, 
    init_arg  => undef, 
    reader    => 'get_name', 
    predicate => '_has_name'
); 

has 'arg' => ( 
    is        => 'rw', 
    isa       => Int, 
    init_arg  => undef, 
    reader    => 'get_arg', 
    predicate => '_has_arg', 
    lazy      => 0, 
    default   => 0,
); 

sub pkg_opt {
    my $self = shift; 
    my @opts = (); 

    push @opts, $self->get_name; 
    push @opts, $self->get_arg if $self->_has_arg; 

    for (sort grep !/(name|arg)/, $self->meta->get_attribute_list) { 
        my $has = "_has_$_"; 
        my $get = "get_$_"; 
    
        push @opts, $_, $self->$get if $self->$has
    }

    return [@opts]
} 

1
