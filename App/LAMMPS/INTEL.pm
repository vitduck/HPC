package HPC::App::LAMMPS::INTEL; 

use Moose; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 

use HPC::App::LAMMPS::Types qw/Suffix/; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => ( 
    default => 'intel',
    trigger => sub { shift->_reset_cmd },
); 

has 'Nphi' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
    trigger => sub { shift->_reset_cmd },
); 

has 'mode' => ( 
    is        => 'rw', 
    isa       => enum([qw/single mixed double/]),
    default   => 'mixed',
    predicate => 'has_mode',
    trigger => sub { shift->_reset_cmd },
); 

has 'omp' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => 'has_omp',
    trigger => sub { shift->_reset_cmd },
); 

has 'lrt' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    predicate => 'has_lrt',
    trigger => sub { shift->_reset_cmd },
); 

has 'balance' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => 'has_balance',
    trigger => sub { shift->_reset_cmd },
); 

has 'ghost' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    predicate => 'has_ghost',
    trigger => sub { shift->_reset_cmd },
); 

has 'tpc' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => 'has_tpc',
    trigger => sub { shift->_reset_cmd },
); 

has 'tptask' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => 'has_tptask',
    trigger => sub { shift->_reset_cmd },
); 

has 'no_affinity' => ( 
    is        => 'rw', 
    isa       => Bool,
    predicate => 'has_no_affinity',
    trigger => sub { shift->_reset_cmd },
); 

has '+_opt' => ( 
    default => sub {[qw/omp mode lrt balance ghost tpc tptask/]}
); 

around 'options' => sub {
    my ($opt, $self) = @_; 
    
    return ['intel', $self->Nphi, $self->$opt->@*]
}; 

__PACKAGE__->meta->make_immutable;

1
