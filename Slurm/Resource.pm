package HPC::Slurm::Resource; 

use Moose::Role;
use MooseX::Types::Moose qw(Str Int ArrayRef);

use namespace::autoclean; 
use experimental 'signatures';

has nodelist => ( 
    is        => 'rw', 
    isa       => ArrayRef,
    traits    => ['Chained'],
    predicate => '_has_nodelist', 
    clearer   => '_clear_nodelist', 
    lazy      => 1, 
    default   => sub {[]}, 
    trigger   => sub ($self, @) { 
        $self->_unset_option
    }

); 

has exclude => ( 
    is        => 'rw', 
    isa       => ArrayRef,
    traits    => ['Chained'],
    predicate => '_has_exclude', 
    clearer   => '_clear_exclude', 
    lazy      => 1, 
    default   => sub {[]}, 
    trigger   => sub ($self, @) { 
        $self->_unset_option
    }
); 

has mem => ( 
    is        => 'rw', 
    isa       => Str, 
    predicate => '_has_mem', 
    traits    => ['Chained'],
    lazy      => 1, 
    default   => 0,
    trigger   => sub ($self, @) { 
        $self->_unset_option
    }

); 

1
