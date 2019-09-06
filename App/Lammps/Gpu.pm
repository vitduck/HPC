package HPC::App::Lammps::Gpu; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num Int Str/; 
use HPC::App::Types::Lammps qw(Ngpu); 
use namespace::autoclean; 

has 'ngpu' => ( 
    is      => 'rw', 
    isa     => Ngpu, 
    coerce  => 1, 
    default => 0,
    writer  => 'set_ngpu'
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    predicate => '_has_neigh', 
    writer    => 'set_neigh'
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    predicate => '_has_newton', 
    writer    => 'set_newton'
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => '_has_binsize',
    writer    => 'set_binsize'
); 

has 'split' => ( 
    is        => 'rw', 
    isa       => Num,
    default   => 1.0,
    predicate => '_has_split', 
    writer    => 'set_split'
); 

has 'gpuID' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => '_has_gpuID', 
    writer    => 'set_gpuID',
); 

has 'tpa' => ( 
    is        => 'rw', 
    isa       => Int, 
    default   => 0,
    predicate => '_has_tpa', 
    writer    => 'set_tpa'
); 

has 'device' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => '_has_device', 
    writer    => 'set_device'
); 

has 'blocksize' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => '_has_blocksize', 
    writer    => 'set_blocksize'
); 

sub pkg_opt { 
    my $self = shift; 
    my @pkgs = ($self->ngpu); 
    
    for my $attr ( grep !/ngpu/, $self->meta->get_attribute_list ) { 
        my $predicate = "_has_$attr"; 
    
        push @pkgs, $attr, $self->$attr if $self->$predicate; 
    }
    
    return [@pkgs]
} 

__PACKAGE__->meta->make_immutable;

1
