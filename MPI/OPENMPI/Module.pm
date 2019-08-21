package HPC::MPI::OPENMPI::Module; 

use Moose; 
use HPC::MPI::OPENMPI::Options qw(OMP_OPENMPI ENV_OPENMPI); 
use namespace::autoclean; 

with 'HPC::MPI::Role', 
     'HPC::MPI::OPENMPI::MCA'; 

has '+omp' => ( 
    isa    => OMP_OPENMPI, 
    coerce => 1
); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_mca(btl_openib_eager_limit => $self->eagersize); 
    }
); 

has '+env' => ( 
    isa    => ENV_OPENMPI, 
    coerce => 1
); 

sub opt { 
    my $self = shift; 
    my @opts = (); 

    push @opts, $self->mca($self->_mca) if $self->has_mca; 
    push @opts, $self->env($self->_mca) if $self->has_env; 
    push @opts, $self->omp              if $self->has_omp; 

    return @opts; 
};  

__PACKAGE__->meta->make_immutable;

1
