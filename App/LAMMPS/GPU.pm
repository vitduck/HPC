package HPC::App::LAMMPS::GPU; 

use Moose; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw/Num Int Str/; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => ( 
    default => 'gpu'
); 

has 'Ngpu' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

has 'neigh' => ( 
    is      => 'rw', 
    isa     => enum([qw/full half/]), 
    trigger => sub { shift->_reset_package }
); 

has 'newton' => ( 
    is      => 'rw', 
    isa     => enum([qw/off on/]), 
    trigger => sub { shift->_reset_package }
); 

has 'binsize' => ( 
    is      => 'rw', 
    isa     => Num,
    trigger => sub { shift->_reset_package }
); 

has 'split' => ( 
    is      => 'rw', 
    isa     => Num,
    default => 1.0,
    trigger => sub { shift->_reset_package }
); 

has 'gpuID' => ( 
    is      => 'rw', 
    isa     => Str, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

has 'tpa' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

has 'device' => ( 
    is      => 'rw', 
    isa     => Str, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

has 'blocksize' => ( 
    is      => 'rw', 
    isa     => Str, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

sub _build_package { 
    my $self = shift; 
    my @opts = ();  

    push @opts, 'gpu', $self->Ngpu; 

    for (qw/neigh newton binsize split gpuID tpa device blocksize/) { 
        push @opts, s/_/\//r, $self->$_ if $self->$_; 
    }

    return join(' ', @opts); 
} 

__PACKAGE__->meta->make_immutable;

1
