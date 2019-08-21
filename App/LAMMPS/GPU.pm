package HPC::App::LAMMPS::GPU; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num Int Str/; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => ( 
    default => 'gpu', 
    trigger => sub { shift->_reset_cmd },
); 

has 'Ngpu' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
    trigger => sub { shift->_reset_cmd },
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/full half/]), 
    predicate => 'has_neigh', 
    trigger   => sub { shift->_reset_cmd },
); 

has 'newton' => ( 
    is        => 'rw', 
    isa       => enum([qw/off on/]), 
    predicate => 'has_newton', 
    trigger   => sub { shift->_reset_cmd },
); 

has 'binsize' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => 'has_binsize',
    trigger   => sub { shift->_reset_cmd },
); 

has 'split' => ( 
    is        => 'rw', 
    isa       => Num,
    default   => 1.0,
    predicate => 'has_split', 
    trigger   => sub { shift->_reset_cmd },
); 

has 'gpuID' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => 'has_gpuID', 
    trigger   => sub { shift->_reset_cmd },
); 

has 'tpa' => ( 
    is        => 'rw', 
    isa       => Int, 
    default   => 0,
    predicate => 'has_tpa', 
    trigger   => sub { shift->_reset_cmd },
); 

has 'device' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => 'has_device', 
    trigger   => sub { shift->_reset_cmd },

); 

has 'blocksize' => ( 
    is        => 'rw', 
    isa       => Str, 
    default   => 0,
    predicate => 'has_blocksize', 
    trigger   => sub { shift->_reset_cmd },
); 

has '+_opt' => ( 
    default => sub {[qw/neigh newton binsize split gpuID tpa device blocksize/]}
); 

around 'options' => sub {
    my ($opt, $self) = @_; 
    
    return ['gpu', $self->Ngpu, $self->$opt->@*]
}; 

__PACKAGE__->meta->make_immutable;

1
