package HPC::Sched::Cmd; 

use Moose::Role; 
use MooseX::Types::Moose 'ArrayRef'; 
use List::Util 'max'; 
use Text::Tabs; 
use feature qw(signatures); 
no warnings qw(experimental::signatures);

has 'cmd' => (
    is        => 'rw',
    isa       => ArrayRef,
    init_arg  => undef,
    traits    => [qw(Array Chained)],
    predicate => '_has_cmd',
    clearer   => 'reset_cmd',
    lazy      => 1, 
    default   => sub {[]},
    handles   => { 
         _add_cmd => 'push', 
        _list_cmd => 'elements' 
    }
);

sub add ($self, @cmds) { 
    for my $cmd ( @cmds ) { 
        my $level = 0; 

        $self->_add_cmd( $self->_expand_cmd(\$level, $cmd) )              if ref $cmd eq ''; 
        $self->_add_cmd([$self->_expand_cmd(\$level, $cmd)])              if ref $cmd eq ref {}; 
        $self->_add_cmd([map $self->_expand_cmd(\$level, $_), $cmd->@* ]) if ref $cmd eq ref []
    }

    return $self; 
}

sub _expand_tab ($self, $level, @lines) { 
    $tabstop = 4;

    return expand(map "\t"x($level).$_, @lines)
}

sub _expand_cmd ($self, $level, $cmd) { 
    if (ref $cmd eq 'HASH') { 
        my ($bin, $opt) = $cmd->%*; 

        return ( 
            $self->_expand_tab($level->$*++, $bin),  
            $self->_expand_tab($level->$*  , $opt->@*) )
    } else { 
        return 
            $self->_expand_tab($level->$*++, $cmd)
    }
} 

sub write_cmd ($self) { 
    my $length; 

    for my $cmd ($self->_list_cmd) { 
        $self->print("\n"); 

        if (ref $cmd eq '') {
            $self->printf("%s\n", $cmd)
        } else { 
            $length = max(map length($_), $cmd->@*); 

            $self->printf("%s\n", join(" \\\n", map sprintf("%-${length}s", $_), $cmd->@* ))
        }
    } 

    return $self
} 

1
