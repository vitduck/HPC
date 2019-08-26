package HPC::PBS::Job; 

use Moose;
use Moose::Util          qw(apply_all_roles); 
use MooseX::Types::Moose qw(Str);
use namespace::autoclean;

with qw(HPC::Debug::Data
        HPC::Env::Module
        HPC::PBS::Cmd
        HPC::PBS::Resource
        HPC::PBS::IO
        HPC::PBS::Numa); 

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

after 'source_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->load_mpi($module); 
};  

after 'unsource_mpi' => sub { 
    my ($self, $module) = @_; 
    
    $self->unload_mpi; 
}; 

# since MPI role is applied to instance of class, 
# pre-installed predicate method based on 'exists' does not work 
# here we introspect the object using metaclass
sub has_mpi { 
    my $self = shift; 

    return grep /^mpi$/, $self->meta->get_attribute_list 
} 

sub load_mpi { 
    my ($self, $module) = @_;
    my ($mpi, $version) = split /\//, $module;  
    
    if ($mpi =~ /(impi|openmpi|mvapich2)/) {   
    
        # apply corresponding MPI roles
        apply_all_roles($self, join '::', qw(HPC PBS MPI), uc($1));

        $self->mpi->set_module ($mpi); 
        $self->mpi->set_version($version); 
        $self->mpi->set_nprocs ($self->select*$self->mpiprocs);

        # set the lazy omp attribute inside MPI class  
        $self->mpi->set_omp($self->omp) if $self->has_omp; 
    }
} 

sub qsub { 
    my $self = shift; 
    
    system 'qsub', $self->pbs; 
} 

sub BUILD { 
    my $self = shift; 

    $self->initialize(); 
}

__PACKAGE__->meta->make_immutable;

1
