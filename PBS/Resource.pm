package HPC::PBS::Resource; 

use Moose::Role; 
use Moose::Util::TypeConstraints; 

has 'select' => ( 
    is       => 'rw', 
    isa      => 'Int', 
    default  => 1,
); 

has 'ncpus' => ( 
    is      => 'rw',
    isa     => 'Int', 
    default => 1,
    trigger => sub { 
        my $self = shift; 
        $self->_reset_mpiprocs; 
        $self->mpiprocs; 
    } 
); 

has 'mpiprocs' => ( 
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1, 
    default => sub { 
        my $self = shift; 
        return $self->ncpus / $self->ompthreads
    }, 
    clearer => '_reset_mpiprocs'
); 

has 'ompthreads' => (
    is      => 'rw',
    isa     => 'Int', 
    default => 1,
    trigger => sub { 
        my $self = shift; 
        $self->_reset_mpiprocs; 
        $self->mpiprocs; 
    }
);

has 'walltime' => ( 
    is      => 'rw', 
    isa     => 'Str',
    default => '48:00:00', 
); 

1
