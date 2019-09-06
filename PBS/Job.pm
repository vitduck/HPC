package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with qw(
    HPC::Debug::Data
    HPC::PBS::IO HPC::PBS::Resource HPC::PBS::Module 
    HPC::PBS::App HPC::PBS::Cmd HPC::PBS::Sys
);   

after 'src_mpi' => sub {
    my ($self, $mpi) = @_; 
    
    $self->_load_impi($mpi); 
};  

after 'unsrc_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->_unload_mpi; 
}; 

before qr/aps_cmd/ => sub {
    my $self = shift; 

    $self->_push_cmd($self->get_aps_type  ) if ($self->has_aps_type); 
    $self->_push_cmd($self->get_aps_level ) if $self->has_aps_level; 
    $self->_push_cmd('' )                   if $self->has_aps_level or $self->has_aps_type;  
}; 

sub qsub { 
    my $self = shift; 
    
    system 'qsub', $self->pbs; 
} 

sub BUILD {
    my $self = shift;

    # unload modules previously loaded
    $self->init; 
}

__PACKAGE__->meta->make_immutable;

1
