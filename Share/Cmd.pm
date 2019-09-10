package HPC::Share::Cmd;  

use Moose::Role; 
use MooseX::Types::Moose qw/Str/; 
use Text::Tabs; 

requires qw(_get_opts); 

has 'bin' => ( 
    is     => 'rw',
    isa    => Str,
    reader => 'get_bin', 
    writer => 'set_bin'
); 

sub cmd {
    $tabstop = 4;
    my $self = shift;
    my @opts = ();

    # flatten cmd options
    for ($self->_get_opts) {
        my $has = "_has_$_";
        my $get = "get_$_"; 

        if ($self->$has and $self->$get) {
            ref $self->$get eq 'ARRAY'
            ? push @opts, (map { "\t" . $_ } $self->$get->@*)
            : push @opts, "\t" . $self->$get
        }
    }

    return [$self->get_bin, expand(@opts)]
}

1
