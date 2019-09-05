package HPC::PBS::Cmd; 

use Moose::Role; 
use MooseX::Types::Moose qw(ArrayRef); 

use List::Util qw(max); 
use Text::Tabs; 

has 'cmd' => (
    is      => 'rw',
    isa     => ArrayRef,
    traits  => ['Array'],
    lazy    => 1, 
    clearer => '_reset_cmd',
    default => sub { ['','cd $PBS_O_WORKDIR'] }, 
    handles => { 
        _push_cmd    => 'push',
        _unshift_cmd => 'unshift',
        _list_cmd    => 'elements' 
    }, 
);

sub add_cmd { 
    my ($self, @cmds) = @_; 

    my $level  = 0; 
    my $maxlen = 0; 
    my @lines  = (); 

    $tabstop = 4; 
    
    # pad the command with tabs 
    # then convert tabs to space
    for my $cmd (@cmds) { 
        ref $cmd eq 'ARRAY' 
        ? push @lines, expand(map { "\t"x($level) . $_ } $cmd->@*)
        : push @lines, expand("\t"x($level).$cmd); 

        $level++; 
    } 

    # max length for line break
    $maxlen = max(map length($_), @lines); 

    $self->_push_cmd(''); 
    $self->_push_cmd([map { sprintf("%-${maxlen}s", $_) } @lines])
} 

sub _write_pbs_cmd {
    my $self = shift;  

    for my $cmd ( $self->_list_cmd ) {  
        ref $cmd eq 'ARRAY' 
        ? $self->printf("%s\n", join(" \\\n", $cmd->@*)) 
        : $self->printf("%s\n", $cmd);                    
    }
}

1
