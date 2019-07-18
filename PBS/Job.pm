package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with qw( 
    MooseX::Traits
    HPC::Env::Module
    HPC::PBS::Debug 
    HPC::PBS::FH 
    HPC::PBS::MPI 
    HPC::PBS::Qsub
    HPC::PBS::App
); 

has 'cmd' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => 'ArrayRef[Str]',
    lazy    => 1, 
    default => sub {['cd $PBS_O_WORKDIR']},
    handles => { 
        _add_cmd  => 'push',
        _list_cmd => 'elements' 
    }, 
    clearer => '_reset_cmd', 
);

sub add_cmd { 
    my ($self, @args) = @_; 

    $self->_add_cmd(
        @args == 1 ? 
        @args : 
        join ' ', @args
    )
} 

sub qsub {
    my $self = shift; 

    system 'qsub', $self->script;  
} 

sub BUILD {
    my $self = shift; 

    $self->initialize; 
    $self->cmd; 
} 

__PACKAGE__->meta->make_immutable;

1
