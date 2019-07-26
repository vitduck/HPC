package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with 'HPC::Debug::Data', 
     'HPC::Env::Module', 
     'HPC::PBS::MPI',
     'HPC::PBS::Cmd',
     'HPC::PBS::Resource',
     'HPC::PBS::Qsub'; 

sub BUILD {
    my $self = shift; 

    $self->initialize; 
} 

__PACKAGE__->meta->make_immutable;

1
