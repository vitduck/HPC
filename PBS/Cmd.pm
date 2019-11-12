package HPC::PBS::Cmd; 

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
    default   => sub {['cd $PBS_O_WORKDIR']},
    handles   => { 
         add_cmd => 'push', 
        list_cmd => 'elements' 
    }
);

sub add ($self, $cmd) { 
    ref $cmd eq ref [] 
        ? $self->_add_multiple($cmd) 
        : $self->_add_single  ($cmd); 

    return $self; 
}

sub _write_pbs_cmd ($self) {
    for my $cmd ($self->list_cmd) { 
        $self->print("\n"); 

        ref $cmd eq ref [] 
            ? $self->_write_multiple($cmd) 
            : $self->_write_single  ($cmd); 
    }

    return $self
}

sub _add_single($self, $cmd) { 
    $self->add_cmd($cmd); 
} 

sub _write_single($self, $cmd) { 
    $self->printf("%s\n", $cmd)
} 

sub _add_multiple($self, $cmd) { 
    my $level = 0; 
    my @cmds  = ();  

    for my $app ($cmd->@*) { 
        #  application w/ options: { bin => [opts] }
        if ( ref $app eq ref {} ) { 
            my ($bin, $opt) = $app->%*; 

            # the options is +1 level w.r.t to bin
            push @cmds,  
                $self->_tab_expand($level++, $bin),  
                $self->_tab_expand($level  , $app->{$bin}->@*);
        # application w/o options: 
        } else { 
            push @cmds, $self->_tab_expand($level++, $app)
        }
    }

    $self->add_cmd([@cmds]); 
} 

sub _write_multiple($self, $cmd) { 
    # reformat command
    my $length = max(map length($_), $cmd->@*); 

    $self->printf(
        "%s\n", 
        join(
            " \\\n", 
            map sprintf("%-${length}s", $_), $cmd->@* 
        )
    )
} 

sub _tab_expand ($self, $level, @lines) { 
    $tabstop = 4; 

    return expand(map "\t"x($level).$_, @lines)
} 

1
