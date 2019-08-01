package HPC::App::LAMMPS::GPU; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num Int Str/; 

with 'HPC::App::LAMMPS::Package'; 

has '+_opt' => ( 
    default => sub {[qw/neigh newton binsize split gpuID tpa device blocksize/]}
); 

has '+suffix' => ( 
    default => 'gpu'
); 

has 'Ngpu' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    predicate => 'has_neigh'
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    predicate => 'has_newton'
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => 'has_binsize'
); 

has 'split' => ( 
    is        => 'rw', 
    isa       => Num,
    default   => 1.0,
    predicate => 'has_split'
); 

has 'gpuID' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => 'has_gpuID'
); 

has 'tpa' => ( 
    is        => 'rw', 
    isa       => Int, 
    default   => 0,
    predicate => 'has_tpa'
); 

has 'device' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => 'has_device'

); 

has 'blocksize' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => 'has_blocksize'
); 

around 'opt' => sub {
    my ($opt, $self) = @_; 
    
    return ['gpu', $self->Ngpu, $self->$opt->@*]
}; 

__PACKAGE__->meta->make_immutable;

1
