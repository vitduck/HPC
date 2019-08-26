package HPC::App::Gromacs::Cmd; 

use Moose::Role; 
use Data::Printer; 

sub cmd { 
    my $self = shift; 
    my @opts = (); 
    my @atrs = grep !/bin/, $self->meta->get_attribute_list;

    for (@atrs) { 
        my $predicate = "has_$_"; 
        
        if ($self->$predicate and $self->$_) {  
            push @opts, $self->$_ 
        }
    } 

    return join(' ', $self->bin, sort @opts); 
} 

1 
