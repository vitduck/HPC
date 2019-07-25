package HPC::PBS::Job; 

use Moose;
use MooseX::Types::Moose qw/ArrayRef Str/; 
use namespace::autoclean;

with 'HPC::Env::Module',
     'HPC::Debug::Data', 
     'HPC::PBS::IO',
     'HPC::PBS::MPI',
     'HPC::PBS::Qsub'; 

has 'cmd' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => ArrayRef[Str],
    lazy    => 1, 
    default => sub {['cd $PBS_O_WORKDIR']},
    handles => { 
        _add_cmd  => 'push',
        _list_cmd => 'elements' 
    }, 
    clearer => 'new_cmd', 
);

sub add_cmd { 
    my ($self, @args) = @_; 

    $self->_add_cmd(
        @args == 1 ? 
        @args : 
        join ' ', @args
    )
} 

before qr/_unload_impi/     => sub { shift->reset_impi_env }; 
before qr/_unload_crayimpi/ => sub { shift->reset_crayimpi_env }; 
before qr/_unload_mvapich2/ => sub { shift->reset_mvapich2_env }; 

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
