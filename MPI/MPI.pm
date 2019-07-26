package HPC::MPI::MPI; 

use Moose::Role;  
use MooseX::Types::Moose qw/Undef Str Int HashRef/; 

requires 
    '_build_env_opt', 
    '_build_omp_opt';  

has 'module' => ( 
    is       => 'ro', 
    isa      => Str, 
    required => 1
); 

has 'version' => ( 
    is       => 'ro', 
    isa      => Str, 
    required => 1
); 

has 'mpirun' => (
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef, 
    default  => 'mpirun', 
); 

has 'omp' => ( 
    is      => 'rw', 
    isa     => Int, 
    lazy    => 1, 
    default => 1, 
    trigger => sub { $_[0]->_clear_omp_opt }
); 

has 'env' => (
    is        => 'rw', 
    isa       => HashRef,
    traits    => ['Hash'],
    init_arg  => undef,
    handles   => { 
        has_env   => 'count', 
        get_env   => 'get', 
        set_env   => 'set',
        unset_env => 'delete',
        reset_env => 'clear', 
        list_env  => 'keys', 
    } 
); 

has 'omp_opt' => ( 
    is      => 'rw', 
    isa     => Str|Undef, 
    lazy    => 1, 
    clearer => '_clear_omp_opt', 
    builder => '_build_omp_opt'
); 

has 'env_opt' => ( 
    is       => 'rw', 
    isa      => Str|Undef, 
    init_arg => undef,
    lazy     => 1,
    clearer  => '_clear_env_opt',  
    builder  => '_build_env_opt'
); 

sub cmd { 
    my $self = shift; 
    
    return 
        join ' ', 
        grep $_, ($self->mpirun, $self->omp_opt, $self->env_opt)
}

1 
