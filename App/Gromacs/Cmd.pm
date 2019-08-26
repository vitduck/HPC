package HPC::App::Gromacs::Cmd; 

use Moose::Role; 
use Text::Tabs;

sub cmd { 
    my $self = shift; 
    my @opts = (); 
    my @atrs = grep !/bin/, $self->meta->get_attribute_list;

    $tabstop = 4; 

    for (@atrs) { 
        my $predicate = "has_$_"; 
        
        if ($self->$predicate and $self->$_) {  
            push @opts, "\t".$self->$_ 
        }
    } 

    return [$self->bin, expand(sort @opts)]
} 

1 
