package HPC::Plugin::Cmd;  

use Moose::Role; 
use MooseX::Types::Moose qw/Str/; 

use experimental 'signatures';  

requires qw(_opts); 

has 'bin' => ( 
    is     => 'rw',
    isa    => Str,
    traits => ['Chained'],
); 

sub cmd ($self) {
    my @opts = ();

    for my $opt ($self->_opts) {
        my $has_opt = "_has_$opt";
        
        if ($self->$has_opt) { 
            push @opts, (
                ref $self->$opt eq ref [] 
                ? $self->$opt->@* 
                : $self->$opt 
            )
        }
    }

    # return a hash ref
    return { $self->bin => \@opts }
}

1
