package HPC::Pbs::Job;  

use Moose;
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use MooseX::XSAccessor; 

use HPC::Types::Sched::Pbs 'Option';  

use namespace::autoclean;
use experimental 'signatures';

with qw( HPC::Sched::Job HPC::Pbs::Resource); 

has '+burst_buffer' => ( 
    trigger => sub ($self, @) { 
        $self->project('burst_buffer')
    } 
); 

has '+_option' => ( 
    isa    => Option,
    coerce => 1,
); 

# rebuild resource string 
after [qw(select mpiprocs omp)] => sub { 
    my $self = shift; 

    if (@_) {
        $self->_unset_resource; 
        $self->resource; 
    }
}; 

# passing hostname/mpirpocs to mvapich2
after 'mvapich2' => sub {  
    my $self = shift; 

    $self->mvapich2->hostfile('$PBS_NODEFILE')->nprocs('$(wc -l $PBS_NODEFILE | awk \'{print $1}\')') if @_;  
}; 

sub _sched_options ($self) { 
    return qw(export queue name app stderr stdout resource walltime project)
} 

# initialize resource string
sub BUILD ($self, @) { 
    $self->resource; 
} 

__PACKAGE__->meta->make_immutable;

1
