package HPC::Pbs::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int ArrayRef);
use Set::CrossProduct; 

use HPC::Types::Sched::Pbs qw(Export Project Burst_Buffer Resource); 

use experimental 'signatures';
use namespace::autoclean; 

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

has 'burst_buffer' => ( 
    is        => 'ro', 
    isa       => Burst_Buffer,
    predicate => '_has_burst_buffer',
    coerce    => 1, 
    lazy      => 1,
    default   => 0 
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
    }
); 

sub write_resource ($self) {
    $self->printf("%s\n\n", $self->shell);

    # build resource string
    $self->resource; 

    for (qw(export queue name app stderr stdout resource walltime burst_buffer)) {
        my $has = "_has_$_";
        if ( $self->$has ) { $self->printf("%s\n", $self->$_) } 
    }

    $self->printf("\n"); 

    return $self
}

1
