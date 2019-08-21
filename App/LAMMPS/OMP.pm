package HPC::App::LAMMPS::OMP; 

use Moose; 
use MooseX::Types::Moose qw/Int Str/; 
use Moose::Util::TypeConstraints; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => (
    default => 'omp',
);

has 'nthreads' => ( 
    is      => 'rw', 
    isa     => Int,
    default => 0, 
    trigger => sub { shift->_reset_cmd }
); 

has 'neigh' => ( 
    is        => 'rw', 
    isa       => enum([qw/yes no/]), 
    predicate => 'has_neigh', 
    trigger   => sub { shift->_reset_cmd }
); 

has '+_opt' => ( 
    default => sub {['neigh']}  
); 

around 'options' => sub {
    my ($opt, $self) = @_; 
    
    return ['omp', $self->nthreads, $self->$opt->@*]
}; 

__PACKAGE__->meta->make_immutable;

1
