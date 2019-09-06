package HPC::App::Gromacs; 

use Moose; 
use Moose::Util::TypeConstraints; 
use namespace::autoclean; 

use Text::Tabs; 

with qw(
    HPC::Debug::Data 
    HPC::App::Base 
    HPC::App::Gromacs::Input
    HPC::App::Gromacs::Output
    HPC::App::Gromacs::Pme
    HPC::App::Gromacs::Thread
    HPC::App::Gromacs::Prof
); 

sub cmd {
    my $self = shift;
    my @opts = ();
    my @atrs = grep !/bin/, $self->meta->get_attribute_list;

    $tabstop = 4;

    for (@atrs) {
        my $predicate = "_has_$_";

        if ($self->$predicate and $self->$_) {
            push @opts, "\t".$self->$_
        }
    }

    return [$self->bin, expand(sort @opts)]
}

__PACKAGE__->meta->make_immutable;

1
