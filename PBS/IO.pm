package HPC::PBS::IO; 

use Moose::Role; 
use Moose::Util::TypeConstraints;

use IO::File; 

subtype 'HPC::PBS::Types::IO' 
    => as 'Object';  

coerce 'HPC::PBS::Types::IO'
    => from 'Str'
    => via { return IO::File->new($_, 'w') }; 

has 'script' => (
    is       => 'rw',
    isa      => 'Str',
    init_arg => undef,
    writer   => 'write_script',
    trigger  => sub { 
        my $self = shift; 

        $self->fh($self->script); 
    } 
); 

has 'fh' => (
    is       => 'rw',
    isa      => 'HPC::PBS::Types::IO',
    init_arg => undef,
    coerce   => 1, 
    handles  => [qw(print printf)], 
    trigger  => sub { 
        my $self = shift; 

        $self->_write_script; 
    }
); 

sub _write_script { 
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
    $self->printf("#PBS -e %s\n", $self->stderr) if $self->has_stderr;  
    $self->printf("#PBS -o %s\n", $self->stdout) if $self->has_stdout; 

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

    # command 
    for my $cmd ($self->_list_cmd) { 
        $self->print("$cmd\n"); 
    } 
} 

1
