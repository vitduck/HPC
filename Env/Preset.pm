package HPC::Env::Preset; 

use Moose::Role; 

has '_preset' => (
    is       => 'ro', 
    isa      => 'HashRef', 
    traits   => ['Hash'], 
    init_arg => undef, 
    lazy     => 1, 
    default  => sub {{ 
        intel => [qw(intel/18.0.3 impi/18.0.3)], 
        cray  => [qw(cce/8.6.3 PrgEnv-cray/1.0.2 cray-impi/1.1.4 cray-libsci/17.09.1 cray-fftw_impi/3.3.6.2)],
        gnu   => [qw(gcc/7.2.0 openmpi/3.1.0 lapack/3.7.0 fftw_mpi/3.3.7)]}
    }, 
    handles  => { 
        get_preset=> 'get'
    } 
); 


sub load_preset { 
    my ($self, $env) = @_; 

    $self->load(
        $self->get_preset($env)->@*
    ); 
} 

sub unload_preset { 
    my ($self, $env) = @_; 
    
    $self->unload(
        reverse $self->get_preset($env)->@*
    ); 
}

sub load_knl { 
    my $self = shift; 

    $self->load('craype-mic-knl'); 
} 

sub load_skl { 
    my $self = shift; 

    $self->load('craype-x86-skylake'); 
}

1 
