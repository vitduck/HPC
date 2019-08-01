package HPC::App::LAMMPS::INTEL; 

use Moose; 
use MooseX::Types::Moose qw/Int Num Bool/; 
use Moose::Util::TypeConstraints; 

use HPC::App::LAMMPS::Types qw/Suffix/; 

with 'HPC::App::LAMMPS::Package'; 

has '+_opt' => ( 
    default => sub {[qw/omp mode lrt balance ghost tpc tptask/]}
); 

has '+suffix' => ( 
    default => 'intel',
); 

has 'Nphi' => ( 
    is      => 'rw', 
    isa     => Int, 
    default => 0,
); 

has 'mode' => ( 
    is        => 'rw', 
    isa       => enum([qw/single mixed double/]),
    default   => 'mixed',
    predicate => 'has_mode',
); 

has 'omp' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => 'has_omp',
); 

has 'lrt' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    predicate => 'has_lrt',
); 

has 'balance' => ( 
    is        => 'rw', 
    isa       => Num,
    predicate => 'has_balance',
); 

has 'ghost' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]),
    predicate => 'has_ghost',
); 

has 'tpc' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => 'has_tpc',
); 

has 'tptask' => ( 
    is        => 'rw', 
    isa       => Int,
    predicate => 'has_tptask',
); 

has 'no_affinity' => ( 
    is        => 'rw', 
    isa       => Bool,
    predicate => 'has_no_affinity',
); 

around 'opt' => sub {
    my ($opt, $self) = @_; 
    
    return ['intel', $self->Nphi, $self->$opt->@*]
}; 

__PACKAGE__->meta->make_immutable;

1
