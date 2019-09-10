package HPC::PBS::Job; 

use Moose;
use MooseX::XSAccessor; 
use namespace::autoclean;

with qw(
    HPC::Debug::Data
    HPC::PBS::IO HPC::PBS::Resource HPC::PBS::Module 
    HPC::PBS::Cmd HPC::PBS::Sys
    HPC::PBS::App 
);   


after 'set_mpivar' => sub {
    my ($self, $module) = @_; 
    
    $self->_load_impi($module); 
};  

before qr/aps_cmd/ => sub {
    my $self = shift; 

    $self->_push_cmd($self->aps->get_type  ) if $self->aps->_has_type; 
    $self->_push_cmd($self->aps->get_level ) if $self->aps->_has_level; 
    $self->_push_cmd('' )                    if $self->aps->_has_level or $self->aps->_has_type; 
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
