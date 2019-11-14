package HPC::PBS::Job; 

use Moose;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

extends 'HPC::Sched::Job'; 

#sub BUILD ($self,@) { 
    #$self->resource; 
#} 

__PACKAGE__->meta->make_immutable;

1
