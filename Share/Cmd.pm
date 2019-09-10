package HPC::Share::Cmd;  

use Moose::Role; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw/Str/; 
use Text::Tabs; 

requires qw(_get_opts); 

has 'bin' => ( 
    is     => 'rw',
    isa    => Str,
    traits => ['Chained'],
); 

sub cmd {
    $tabstop = 4;
    my $self = shift;
    my @opts = ();

    # flatten cmd options
    for ($self->_get_opts) {
        my $has = "_has_$_";

        if ($self->$has and $self->$_) {
            ref $self->$_ eq 'ARRAY'
            ? push @opts, (map { "\t" . $_ } $self->$_->@*)
            : push @opts, "\t" . $self->$_
        }
    }

    return [$self->bin, expand(@opts)]
}

1
