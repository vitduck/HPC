package HPC::PBS::Job; 

use Moose;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use namespace::autoclean;

with qw(
    HPC::Debug::Data
    HPC::PBS::IO HPC::PBS::Resource HPC::PBS::Module 
    HPC::PBS::Cmd HPC::PBS::Sys
    HPC::PBS::App 
);   

after 'mpivar' => sub {
    my ($self, $module) = @_; 
    
    $self->_load_impi($module) if $module; 
};  

before qr/aps_cmd/ => sub {
    my $self = shift; 

    $self->_push_cmd($self->aps->type  ) if $self->aps->_has_type; 
    $self->_push_cmd($self->aps->level ) if $self->aps->_has_level; 
    $self->_push_cmd('' )                if $self->aps->_has_level or $self->aps->_has_type; 
}; 

before 'tensorflow_cmd' => sub { 
    my $self = shift; 

    $self->tensorflow->num_intra_threads($self->omp) if $self->_has_omp 
}; 

sub qsub { 
    my $self = shift; 
    
    system 'qsub', $self->pbs; 

    return $self; 
} 

sub BUILD {
    my $self = shift;

    # unload modules previously loaded
    $self->init; 
}

__PACKAGE__->meta->make_immutable;

1
