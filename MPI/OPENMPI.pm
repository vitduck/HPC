package HPC::MPI::OPENMPI; 

use Moose; 
use namespace::autoclean; 

with 'HPC::MPI::Lib'; 

has '+env_opt' => ( 
    default => '-x'
); 

around cmd => sub { 
    my ($cmd, $self, undef, undef, $omp) = @_; 

    # original cmd 
    my @cmd = $self->$cmd; 

    push @cmd, '--map-by NUMA:PE='.$omp if $omp > 1; 

    return @cmd; 
};

__PACKAGE__->meta->make_immutable;

1
