package HPC::Share::Cmd;  

use Moose::Role; 
use MooseX::Types::Moose qw/Str/; 
use feature 'signatures';  
no warnings 'experimental::signatures'; 

requires qw(_get_opts); 

has 'bin' => ( 
    is     => 'rw',
    isa    => Str,
    traits => ['Chained'],
); 

sub cmd ($self) {
    my @opts = ();

    for my $opt ($self->_get_opts) {
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
