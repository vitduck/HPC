package HPC::PBS::IO; 

use Moose::Role; 
use Text::Tabs;
use List::Util qw(max); 
use Data::Printer; 

use HPC::PBS::Types::IO qw(FH); 

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

sub add_pbs_cmd { 
    my ($self, @refs) = @_; 

    my $level  = 0; 
    my $maxlen = 0; 
    my @cmd    = (); 

    $tabstop = 4; 
    
    # pad the command with tabs 
    # then convert tabs to space
    for my $ref (@refs) { 
        push @cmd, expand(map { "\t"x($level) . $_ } $ref->@*);   
        $level++; 
    } 

    # max length for line break
    $maxlen = max(map length($_), @cmd); 

    # print cmd to pbs
    for my $cmd (@cmd) { 
        $self->printf("%-${maxlen}s \\\n", $cmd)
    } 

} 

sub _write_pbs_opt { 
    my $self = shift; 

    # shell 
    $self->printf("%s\n", $self->shell); 
    $self->printf("\n"); 

    #  pbs header
    $self->printf("#PBS -V\n"); 
    $self->printf("#PBS -A %s\n", $self->account); 
    $self->printf("#PBS -P %s\n", $self->project); 
    $self->printf("#PBS -q %s\n", $self->queue); 
    $self->printf("#PBS -N %s\n", $self->name); 

    # optional 
    $self->printf("#PBS -e %s\n", $self->stderr) if $self->stderr; 
    $self->printf("#PBS -o %s\n", $self->stdout) if $self->stdout; 

    # resource 
    $self->printf(
        "#PBS -l select=%d:ncpus=%d:mpiprocs=%d:ompthreads=%d\n", 
        $self->select, 
        $self->ncpus, 
        $self->mpiprocs,
        $self->omp
    ); 

    $self->printf("#PBS -l walltime=%s\n", $self->walltime); 
    $self->printf("\n"); 
}

sub _write_pbs_module { 
    my $self = shift; 

    $self->printf("module load %s\n", $_) for $self->list_module;
    $self->printf("%s\n", $self->mpivar ) if  $self->mpivar; 
    $self->printf("%s\n", $self->mklvar ) if  $self->mklvar; 
    $self->printf("\n"); 
} 

sub _write_pbs_cmd {
    my $self = shift; 

    my $cmd = join "\n\n", $self->list_cmd; 
    $self->print("$cmd\n"); 
    $self->printf("\n"); 
} 

1
