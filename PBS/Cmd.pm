package HPC::PBS::Cmd; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str ArrayRef/; 
use List::Util qw(max); 
use Text::Tabs; 

has 'cmd' => (
    is      => 'rw',
    traits  => ['Array'],
    isa     => ArrayRef[Str],
    lazy    => 1, 
    default => sub {["cd \$PBS_O_WORKDIR"]},
    handles => { 
         _add_cmd => 'push',
         list_cmd => 'elements' 
    }, 
    clearer => 'new_cmd', 
);

sub add_pbs_cmd { 
    my ($self, @cmds) = @_; 

    my $level  = 0; 
    my $maxlen = 0; 
    my @lines  = (); 

    $tabstop = 4; 
    
    # pad the command with tabs 
    # then convert tabs to space
    for my $cmd (@cmds) { 
        if ( ref $cmd eq 'ARRAY' ) { 
            push @lines, expand(map { "\t"x($level) . $_ } $cmd->@*);   

        } else { 
            push @lines, expand("\t"x($level) . $cmd)
        }
        
        $level++; 
    } 

    # max length for line break
    $maxlen = max(map length($_), @lines); 

    # print cmd to pbs
    for my $line (@lines) { 
        $self->printf("%-${maxlen}s \\\n", $line)
    } 

} 

sub _write_pbs_cmd {
    my $self = shift; 

    my $cmd = join "\n\n", $self->list_cmd; 
    $self->print("$cmd\n"); 
    $self->printf("\n"); 
} 

1
