package HPC::Pbs::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use Set::CrossProduct; 

use experimental 'signatures';
use namespace::autoclean; 

has 'export' => (
    is        => 'ro', 
    isa       => Int,
    init_arg  => undef,
    predicate => '_has_export', 
    default   => 1 
);

has 'project' => ( 
    is        => 'ro', 
    isa       => Str,
    init_arg  => undef,
    predicate => '_has_project',
    lazy      => 1,
    default   => 'burst_buffer', 
    trigger   => sub ($self, @) { 
        $self->_unset_option
    } 
); 

has 'ncpus' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ncpus',
    default   => 64,
    trigger   => sub ($self, @) { 
        $self->_unset_option; 
        $self->_unset_resource; 
    }
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
        $self->_unset_option; 
        $self->_unset_resource;  
    }
); 

has 'resource' => ( 
    is        => 'rw', 
    isa       => Str|ArrayRef,
    init_arg  => undef,
    traits    => ['Chained'],
    predicate => '_has_resource',
    clearer   => '_unset_resource',
    lazy      => 1, 
    default   => sub ($self) { 
        my @resources; 

        push @resources, $self->select;  
        push @resources, join('=', 'ncpus'     ,  $self->ncpus                      );  
        push @resources, join('=', 'mpiprocs'  ,  $self->mpiprocs                   ); 
        push @resources, join('=', 'ompthreads', ($self->_has_omp ? $self->omp : 1) ); 

        if ( $self->_has_host ) { 
            return [ 
                map join(':', $_->@*),
                    Set::CrossProduct->new([ 
                        [join(':', @resources)], 
                        [map "host=$_", $self->get_hosts]]
                    )->combinations->@* 
                ] 
        } else {  
            return join(':', @resources) 
        }
    }, 
);

1
