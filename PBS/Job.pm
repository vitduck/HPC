package HPC::PBS::Job; 

use Moose;
use Moose::Util::TypeConstraints; 
use namespace::autoclean;

with qw( 
    HPC::Env::Module
    HPC::PBS::MPI 
    HPC::PBS::Qsub
); 

sub BUILD {  
    my $self = shift; 

    $self->initialize; 
} 

__PACKAGE__->meta->make_immutable;

1; 
