package HPC::Pbs::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use HPC::Types::Sched::Pbs qw(Export Project Resource); 
use Set::CrossProduct; 
use feature 'signatures';
no warnings 'experimental::signatures';

has 'export' => ( 
    is        => 'ro', 
    isa       =>  Export,
    init_arg  => undef,
    predicate => '_has_export', 
    coerce    => 1, 
    default   => 1 
); 

has 'project' => ( 
    is        => 'ro', 
    isa       => Project,
    init_arg  => undef,
    predicate => '_has_project',
    coerce    => 1, 
    lazy      => 1,
    default   => 'burst_buffer' 
); 

has 'ncpus' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ncpus',
    default   => 64,
);

has 'host' => ( 
    is        => 'rw',
    isa       => ArrayRef,
    traits    => ['Chained','Array'],
    predicate => '_has_host',
    handles   => { 
        get_hosts   => 'elements',
        count_hosts => 'count' }, 
    trigger   => sub ($self, @) { 
        $self->_reset_resource;  
    }
); 

has 'resource' => ( 
    is        => 'rw', 
    isa       => Resource,
    init_arg  => undef,
    traits    => ['Chained'],
    predicate => '_has_resource',
    clearer   => '_reset_resource',
    coerce    => 1,
    lazy      => 1, 
    default   => sub ($self) { 
        my @resources; 

        push @resources, $self->select;  
        push @resources, join('=', 'ncpus'     ,  $self->ncpus );  
        push @resources, join('=', 'mpiprocs'  , ($self->mpi ? $self->mpiprocs : 1));
        push @resources, join('=', 'ompthreads', ($self->omp ? $self->omp      : 1)); 

         
        if ( $self->_has_host ) { 
            return [ map join(':', $_->@*), Set::CrossProduct->new([ [ join(':', @resources)           ], 
                                                                     [ map "host=$_", $self->get_hosts ] ])
                                                             ->combinations
                                                             ->@* ] 
        } else {  
            return join(':', @resources) 
        }
    }
); 

sub write_resource ($self) {
    $self->printf("%s\n\n", $self->shell);

    # build resource string
    $self->resource; 
    for (qw(export name account project queue stderr stdout resource walltime)) {
        my $has = "_has_$_";
        $self->printf("%s\n", $self->$_) if $self->$has;
    }

    return $self
}

1
