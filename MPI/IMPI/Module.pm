package HPC::MPI::IMPI::Module;  

use Moose; 
use HPC::MPI::IMPI::Options qw(ENV_IMPI); 
use namespace::autoclean; 

with qw(HPC::MPI::Base); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env(I_MPI_EAGER_THRESHOLD => $self->eagersize);
    }
); 

has '+env' => ( 
    isa    => ENV_IMPI, 
    coerce => 1
); 

sub opt { 
    my $self = shift; 
    my @opts = (); 

    push @opts, $self->env($self->_env) if $self->has_env; 

    return @opts; 
} 

__PACKAGE__->meta->make_immutable;

1
