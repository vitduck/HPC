package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with qw( 
    HPC::Env::Module
    HPC::PBS::Debug  
    HPC::PBS::IO 
    HPC::PBS::MPI 
    HPC::PBS::Qsub
); 

has 'cmd' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => 'ArrayRef[Str]',
    lazy    => 1, 
    default => sub {['cd $PBS_O_WORKDIR']},
    handles => {
         add_cmd => 'push',
        list_cmd => 'elements', 
    }, 
    clearer => '_reset_cmd', 
);

sub qsub {
    my $self = shift; 

    system 'qsub', $self->pbs; 
} 

sub BUILD {
    my $self = shift; 

    $self->initialize; 
    $self->cmd; 
} 

__PACKAGE__->meta->make_immutable;

1
