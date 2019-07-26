package HPC::PBS::Qsub; 

use Moose::Role; 
use MooseX::Types::Moose qw/Str/;

use HPC::PBS::Types qw/FH/; 

has 'pbs' => (
    is       => 'rw',
    isa      => FH,
    init_arg => undef,
    coerce   => 1, 
    writer   => 'write_pbs',
    handles  => [qw(print printf)], 
    trigger  => sub { 
        my $self = shift; 
        
        $self->_write_pbs_opt; 
        $self->_write_pbs_module; 
        $self->_write_pbs_cmd; 

    }
); 

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
}

sub _write_pbs_module { 
    my $self = shift; 

    $self->printf("module load %s\n", $_) for $self->list_module; 
    $self->printf("# mkl\n%s\n",  $self->source_mkl ) if $self->source_mkl; 
    $self->printf("# impi\n%s\n", $self->source_impi) if $self->source_impi; 
    $self->printf("\n"); 
} 

sub _write_pbs_cmd { 
    my $self = shift; 
    
    # command 
    $self->print("$_\n") for $self->list_cmd; 
} 

1
