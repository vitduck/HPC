package HPC::Sched::Cmd; 

use Moose::Role; 
use MooseX::Types::Moose 'ArrayRef'; 
use List::Util 'max'; 
use Text::Tabs; 

use namespace::autoclean; 
use experimental 'signatures';

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
        add      => 'push', 
        list_cmd => 'elements' }
);

around add => sub ($add, $self, @args) { 
   $self->$add(@args); 

   return $self
}; 

sub write_cmd ($self) { 
    my $level; 

    for my $cmd ($self->list_cmd) { 
        # serial job
        if (ref $cmd eq 'HASH') { 
            $level = 0; 
            $self->_print_indented_cmd(
                $self->_indent_cmd(\$level, $cmd) );  

        # parallel job
        } elsif (ref $cmd eq 'ARRAY') { 
            $level = 0; 
            $self->_print_indented_cmd( 
                map { $self->_indent_cmd(\$level, $_) } $cmd->@* ); 

        # single cmd
        } else {   
            $self->printf("%s\n", $cmd)
        }

        $self->print("\n"); 
    } 

    return $self
} 

sub _expand_tab ($self, $level, @lines) { 
    $tabstop = 4;

    return expand(map "\t"x($level).$_, @lines)
}

sub _indent_cmd ($self, $level, $cmd) { 
    # command with options 
    if (ref $cmd eq 'HASH') { 
        my ($bin, $opt) = $cmd->%*; 

        return ( 
            $self->_expand_tab($level->$*++, $bin),  
            $self->_expand_tab($level->$*  , $opt->@*) )
        
    # simple command 
    } else { 
        return 
            $self->_expand_tab($level->$*++, $cmd)
    }
} 

sub _print_indented_cmd ($self, @cmds) { 
    my $length = max(map length($_), @cmds); 

    $self->printf("%s\n", join(" \\\n", map sprintf("%-${length}s", $_), @cmds))
} 

1
