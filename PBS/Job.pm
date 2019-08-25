package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with qw(HPC::Debug::Data
        HPC::Env::Module
        HPC::PBS::MPI
        HPC::PBS::Cmd
        HPC::PBS::Resource
        HPC::PBS::Qsub
        HPC::PBS::Numa); 

after 'source_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->_load_mpi($module); 
};  

sub BUILD { 
    my $self = shift; 

    $self->initialize(); 
}

__PACKAGE__->meta->make_immutable;

1
