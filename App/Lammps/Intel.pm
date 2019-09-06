package HPC::App::Lammps::Intel; 

use Moose; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 
use HPC::App::Types::Lammps qw(Nphi); 
use namespace::autoclean; 

has 'nphi' => ( 
    is      => 'rw', 
    isa     => Nphi, 
    coerce  => 1, 
    writer  => 'set_nphi',
    default => 0,
); 

has 'mode' => ( 
    is        => 'rw', 
    isa       => enum([qw/single mixed double/]),
    lazy      => 1, 
    predicate => '_has_mode',
    writer    => 'set_mode', 
    default   => 'mixed',
); 

has 'omp' => ( 
    is        => 'rw', 
    isa       => Int,
    lazy      => 1, 
    writer    => 'set_omp',
    predicate => '_has_omp',
    default   => 1
); 

has 'lrt' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    lazy      => 1, 
    predicate => '_has_lrt',
    writer    => 'set_lrt',
    default   => 'no'
); 

has 'balance' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => '_has_balance',
    writer    => 'set_balance',
); 

has 'ghost' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    predicate => '_has_ghost',
    writer    => 'set_ghost',
); 

has 'tpc' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => '_has_tpc',
    writer    => 'set_tpc',
); 

has 'tptask' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => '_has_tptask',
    writer    => 'set_tptask',
); 

sub pkg_opt { 
    my $self = shift; 
    my @pkgs = ($self->nphi); 
    
    for my $attr ( grep !/nphi/, $self->meta->get_attribute_list ) { 
        my $predicate = "_has_$attr"; 
    
        push @pkgs, $attr, $self->$attr if $self->$predicate; 
    }

    return [@pkgs]
} 

__PACKAGE__->meta->make_immutable;

1
