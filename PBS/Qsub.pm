package HPC::PBS::Qsub; 

use Moose::Role; 
use MooseX::Types::Moose qw(Str);
use Text::Tabs;
use List::Util qw(max); 

use HPC::PBS::Types::IO qw(FH); 

has 'pbs' => ( 
    is       => 'rw',
    isa      => Str,
    init_arg => undef, 
    writer   => 'set_pbs',
    trigger  => sub { 
        my $self = shift; 

        $self->_io($self->pbs); 
    }
); 


has '_io' => (
    is       => 'rw',
    isa      => FH,
    init_arg => undef,
    coerce   => 1, 
    handles  => [qw(print printf)], 
    trigger  => sub { 
        my $self = shift; 
        
        $self->_write_pbs_opt; 
        $self->_write_pbs_module; 
        $self->_write_pbs_cmd; 
    }
); 

sub qsub { 
    my $self = shift; 
    
    system 'qsub', $self->pbs; 
} 

1
