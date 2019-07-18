package HPC::PBS::IO; 

use Moose::Role; 
use Moose::Util::TypeConstraints;

use IO::File; 

subtype 'HPC::PBS::Types::IO' 
    => as 'Object';  

coerce 'HPC::PBS::Types::IO'
    => from 'Str'
    => via { return IO::File->new($_, 'w') }; 

has 'pbs' => (
    is       => 'rw',
    isa      => 'HPC::PBS::Types::IO',
    init_arg => undef,
    coerce   => 1, 
    writer   => 'set_pbs',
    handles  => [qw(print printf)], 
    trigger  => sub { shift->_write_pbs }
); 

sub _write_pbs { 
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
    $self->printf("#PBS -e %s\n", $self->name) if $self->stderr;  
    $self->printf("#PBS -o %s\n", $self->name) if $self->stdout; 

    # resource 
    $self->printf(
        "#PBS -l select=%d:ncpus=%d:mpiprocs=%d:ompthreads=%d\n", 
        $self->select, 
        $self->ncpus, 
        $self->mpiprocs,
        $self->ompthreads
    ); 
    $self->printf("#PBS -l walltime=%s\n", $self->walltime); 
    $self->printf("\n"); 

    # command 
    for my $cmd ($self->list_cmd) { 
        $self->print("$cmd\n"); 
    } 
} 

1
