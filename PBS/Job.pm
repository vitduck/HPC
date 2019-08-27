package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with qw(
    HPC::Debug::Data
    HPC::PBS::Resource
    HPC::PBS::Module
    HPC::PBS::Cmd
    HPC::PBS::MPI
    HPC::PBS::NUMA
    HPC::PBS::Qsub ); 

after 'source_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->load_mpi($module); 
};  

after 'unsource_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->unload_mpi; 
}; 

sub BUILD {
    my $self = shift;

    $self->initialize();
}

__PACKAGE__->meta->make_immutable;

1
