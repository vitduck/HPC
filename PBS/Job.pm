package HPC::PBS::Job; 

use Moose;
use namespace::autoclean;

with 'HPC::Debug::Data', 
     'HPC::Env::Module', 
     'HPC::PBS::MPI',
     'HPC::PBS::Cmd',
     'HPC::PBS::Resource',
     'HPC::PBS::Qsub', 
     'HPC::PBS::Numa'; 


after 'load' => sub { 
    my $self     = shift; 
    my ($module) = grep /(cray-impi|impi|openmpi|mvapich2)/, @_; 
    
    $self->_load_mpi($module) if $module;  
}; 

after 'unload' => sub { 
    my $self     = shift; 
    my ($module) = grep /(cray-impi|impi|openmpi|mvapich2)/, @_; 

    $self->_unload_mpi($module) if $module;  
}; 

# propagate PBS resource to MPI class 
after '_load_mpi' => sub { 
    my $self = shift; 
    my $mpi  = $self->_mpi; 

    $self->$mpi->nprocs($self->select * $self->ncpus); 
    $self->$mpi->omp   ($self->omp); 
};

after 'set_omp' => sub { 
    my $self  = shift; 
    my $mpi  = $self->_mpi; 

    $self->$mpi->omp($self->omp) if $mpi;  
};  

after [qw(set_select set_ncpus)] => sub {  
    my $self  = shift; 
    my $mpi  = $self->_mpi; 
    
    $self->$mpi->nprocs($self->select*$self->ncpus) if $mpi; 
}; 

sub BUILD { 
    my $self = shift; 

    $self->initialize(); 
}

__PACKAGE__->meta->make_immutable;

1
