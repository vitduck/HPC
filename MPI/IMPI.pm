package HPC::MPI::IMPI;  

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose  qw(Int Bool); 
use HPC::MPI::Types::IMPI qw(ENV_IMPI); 
use namespace::autoclean; 

extends qw(HPC::MPI::Base);  

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 
        
        $self->set_env( I_MPI_EAGER_THRESHOLD => $self->eagersize );
    }
); 

has '+env_opt' => (
    isa      => ENV_IMPI, 
    coerce   => 1, 
); 

has 'debug' => ( 
    is       => 'rw', 
    isa      => Int, 
    traits   => ['Chained'],
    init_arg => undef,
    lazy     => 1, 
    default  => 3, 
    trigger  => sub { 
        my $self = shift; 

        $self->set_env( I_MPI_DEBUG => $self->debug );  
    }
); 

override _get_opts => sub { 
    return qw(env_opt); 
}; 

__PACKAGE__->meta->make_immutable;

1
