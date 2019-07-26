package HPC::App::LAMMPS::INTEL; 

use Moose; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 

use HPC::App::LAMMPS::Types qw/Suffix/; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => ( 
    default => 'intel',
); 

has 'suffix' => ( 
    is      => 'rw',
    isa     => Suffix,
    coerce  => 1, 
    default => 'intel',
); 

has 'Nphi' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
    trigger => sub { shift->_reset_package }
); 

has 'mode' => ( 
    is      => 'rw', 
    isa     => enum([qw/single mixed double/]),
    trigger => sub { shift->_reset_package }
); 

has 'omp' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'lrt' => ( 
    is      => 'rw', 
    isa     => enum([qw/yes no/]),
    trigger => sub { shift->_reset_package }
); 

has 'balance' => ( 
    is      => 'rw', 
    isa     => Num,
    trigger => sub { shift->_reset_package }
); 

has 'ghost' => ( 
    is      => 'rw', 
    isa     => enum([qw/yes no/]),
    trigger => sub { shift->_reset_package }
); 

has 'tpc' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'tptask' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'no_affinity' => ( 
    is      => 'rw', 
    isa     => Bool,
    trigger => sub { shift->_reset_package }
); 

sub _build_package { 
    my $self = shift; 
    my @opts = (); 

    # required 
    push @opts, 'intel', $self->Nphi; 
    for (qw/mode omp lrt balance ghost tpc tptask/) { 
        push @opts, $_, $self->$_ if $self->$_; 
    }

    # single keyowrd
    push @opts, 'no_afinity' if $self->no_affinity; 

    return join(' ', @opts) 
} 

__PACKAGE__->meta->make_immutable;

1
