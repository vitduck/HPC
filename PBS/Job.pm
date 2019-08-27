package HPC::PBS::Job; 

use Moose;
use Moose::Util qw(apply_all_roles); 
use namespace::autoclean;

with qw(
    HPC::Debug::Data
    HPC::PBS::Numa
    HPC::PBS::Resource
    HPC::PBS::Module
    HPC::PBS::Cmd
    HPC::PBS::Qsub ); 

after 'source_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->load_mpi($module); 
};  

after 'unsource_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->unload_mpi; 
}; 

# since MPI role is applied to instance of class, 
# pre-installed predicate method based on 'exists' does not work 
# here we introspect the object using metaclass
sub has_mpi { 
    my $self = shift; 

    return grep /^mpi$/, $self->meta->get_attribute_list 
} 

sub load_mpi { 
    my ($self, $module) = @_;
    
    if ($module =~ /(impi|openmpi|mvapich2)/) {   
    
        # apply corresponding MPI roles
        apply_all_roles($self, join '::', qw(HPC PBS MPI), uc($1));

        $self->mpi->set_module($module); 
        $self->mpi->set_nprocs($self->select*$self->mpiprocs);

        # set the lazy omp attribute inside MPI class  
        $self->mpi->set_omp($self->omp) if $self->has_omp; 
    }
} 

sub BUILD { 
    my $self = shift; 

    $self->initialize(); 
}

__PACKAGE__->meta->make_immutable;

1
