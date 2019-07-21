package HPC::App::LAMMPS::INTEL; 

use Moose; 
use MooseX::Types::Moose qw/Int/; 
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

has 'nphi' => ( 
    is      => 'rw', 
    isa     => Int, 
    trigger => sub { shift->_reset_package }
); 

has 'omp' => ( 
    is      => 'rw', 
    isa     => Int,
    trigger => sub { shift->_reset_package }
); 

has 'mode' => ( 
    is      => 'rw', 
    isa     => enum([qw/single mixed double/]),
    trigger => sub { shift->_reset_package }
); 

has 'lrt' => ( 
    is      => 'rw', 
    isa     => enum([qw/ues no/]),
    trigger => sub { shift->_reset_package }
); 

sub _build_package { 
    my $self = shift; 
    my @opts = (); 

    # required 
    push @opts, 'intel', $self->nphi; 

    for (qw/omp mode lrt/) { 
        push @opts, $_, $self->$_ if $self->$_; 
    }

    return join(' ', @opts) 
} 

sub cmd { 
    my $self = shift; 

    return join ' ', $self->suffix, $self->package; 
} 

__PACKAGE__->meta->make_immutable;

1
