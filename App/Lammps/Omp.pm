package HPC::App::Lammps::Omp; 

use Moose; 
use MooseX::Types::Moose qw/Int Str/; 
use Moose::Util::TypeConstraints; 
use HPC::App::Types::Lammps qw(Nthread); 
use namespace::autoclean; 

has 'nthreads' => ( 
    is      => 'rw', 
    isa     => Nthread, 
    writer  => 'set_nthreads',
    coerce  => 1, 
    default => 0, 
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]), 
    writer    => 'set_neigh',
    predicate => '_has_neigh', 
); 

sub pkg_opt { 
    my $self = shift; 
    my @pkgs = ($self->nthreads); 
    
    for my $attr ( grep !/nthreads/, $self->meta->get_attribute_list ) { 
        my $predicate = "_has_$attr"; 
    
        push @pkgs, $attr, $self->$attr if $self->$predicate; 
    }

    return [@pkgs]
} 

__PACKAGE__->meta->make_immutable;

1
