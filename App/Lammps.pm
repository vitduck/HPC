package HPC::App::Lammps;

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Types::Moose qw(ArrayRef); 
use HPC::App::Lammps::Opt; 
use HPC::App::Lammps::Omp; 
use HPC::App::Lammps::Gpu; 
use HPC::App::Lammps::Intel; 
use HPC::App::Lammps::Kokkos; 
use HPC::App::Types::Lammps qw(
    Suffix Kokkos_Thr Inp Log Var Pkg 
    Pkg_Opt Pkg_Omp Pkg_Gpu Pkg_Intel Pkg_Kokkos
); 
use namespace::autoclean; 

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data 
);  

has 'suffix' => (
    is        => 'rw',
    isa       => Suffix,
    coerce    => 1, 
    reader    => 'get_suffix',
    writer    => 'set_suffix',  
    clearer   => '_unset_suffix',
    predicate => '_has_suffix', 
); 

has 'kokkos_thr' => ( 
    is        => 'rw', 
    isa       => Kokkos_Thr, 
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_kokkos_thr',
    writer    => 'set_kokkos_thr',   
    clearer   => '_unset_kokkos_thr', 
    predicate => '_has_kokkos_thr', 
    default   => 1, 
); 

has 'inp' => ( 
    is        => 'rw',
    isa       => Inp, 
    coerce    => 1, 
    reader    => 'get_inp',
    writer    => 'set_inp', 
    predicate => '_has_inp',
); 

has 'log' => (
    is        => 'rw',
    isa       => Log, 
    coerce    => 1, 
    reader    => 'get_log',
    writer    => 'set_log', 
    predicate => '_has_log',
    default   => 'log.lammps'
); 

has 'var' => ( 
    is        => 'rw',
    isa       => Var, 
    coerce    => 1, 
    reader    => 'get_var',
    writer    => 'set_var',
    predicate => '_has_var',
); 

has 'pkg' => ( 
    is        => 'rw', 
    isa       => Pkg, 
    coerce    => 1, 
    lazy      => 1, 
    reader    => 'get_pkg',
    writer    => 'set_pkg',
    predicate => '_has_pkg', 
    default   => sub { [] }, 
); 

# accelerator package
has opt => ( 
    is        => 'rw',
    isa       => Pkg_Opt,
    coerce    => 1, 
    lazy      => 1, 
    writer    => 'set_opt',
    clearer   => 'unset_opt',
    predicate => '_has_opt',
    default   => sub {{}}, 
    trigger   => sub { shift->set_suffix('opt') }
); 

has omp => ( 
    is        => 'rw',
    isa       => Pkg_Omp, 
    coerce    => 1, 
    lazy      => 1, 
    writer    => 'set_omp', 
    clearer   => 'unset_omp', 
    predicate => '_has_omp',
    default   => sub { {} }, 
    trigger   => sub { shift->set_suffix('omp') }, 
    handles   => { 
        set_omp_nthreads => 'set_nthreads', 
        set_omp_neigh    => 'set_neigh',
    }, 
); 

has gpu => (
    is        => 'rw',
    isa       => Pkg_Gpu,
    coerce    => 1, 
    lazy      => 1, 
    writer    => 'set_gpu',
    clearer   => 'unset_gpu', 
    predicate => '_has_gpu',
    default   => sub { {} }, 
    trigger   => sub { shift->set_suffix('gpu') }, 
    handles   => { 
        set_gpu_ngpu      => 'set_ngpu',
        set_gpu_neigh     => 'set_neigh',
        set_gpu_newton    => 'set_newton',
        set_gpu_binsize   => 'set_binsize',
        set_gpu_split     => 'set_split',
        set_gpu_gpuID     => 'set_gpuID',
        set_gpu_tpa       => 'set_tpa',
        set_gpu_device    => 'set_device', 
        set_gpu_blocksize => 'set_blocksize'
    }, 
); 

has intel => ( 
    is        => 'rw',
    isa       => Pkg_Intel,
    coerce    => 1, 
    lazy      => 1, 
    writer    => 'set_intel',
    clearer   => 'unset_intel',
    predicate => '_has_intel',
    default   => sub { {} }, 
    trigger   => sub { shift->set_suffix('intel') }, 
    handles   => { 
        set_intel_nphi    => 'set_nphi',
        set_intel_mode    => 'set_mode',
        set_intel_omp     => 'set_omp',
        set_intel_lrt     => 'set_lrt',
        set_intel_balance => 'set_balance',
        set_intel_ghost   => 'set_ghost',
        set_intel_tpc     => 'set_tpc',
        set_intel_tptask  => 'set_tptask',
    }, 
); 

has kokkos => ( 
    is        => 'rw',
    isa       => Pkg_Kokkos,
    coerce    => 1, 
    lazy      => 1, 
    writer    => 'set_kokkos',
    clearer   => 'unset_kokkos',
    predicate => '_has_kokkos',
    default   => sub { {} }, 
    trigger   => sub { 
        my $self = shift; 
        
        $self->set_suffix('kk'); 
        $self->set_kokkos_thr(1); 
    }, 
    handles   => { 
        set_kokkos_neigh         => 'set_neigh',
        set_kokkos_neigh_qeq     => 'set_neigh_qeq',
        set_kokkos_neigh_thread  => 'set_neigh_thread',
        set_kokkos_newton        => 'set_newton',
        set_kokkos_binsize       => 'set_binsize',
        set_kokkos_comm          => 'set_comm',
        set_kokkos_comm_exchange => 'set_comm_exchange',
        set_kokkos_comm_forward  => 'set_comm_forward',
        set_kokkos_comm_reverse  => 'set_comm_reverse',
        set_kokkos_gpu_direct    => 'set_gpu_direct',
    }, 
    ); 

after qr/^unset_(opt|omp|gpu|intel|kokkos)/ => sub { 
    my $self = shift; 

    $self->_unset_suffix; 
    $self->_unset_kokkos_thr; 
    $self->_unset_pkg; 
}; 

after qr/^set_omp_.*/ => sub { 
    my $self = shift; 

    $self->set_pkg($self->omp->pkg_opt); 
};  

after qr/^set_gpu_.*/ => sub { 
    my $self = shift; 

    $self->set_pkg($self->gpu->pkg_opt); 
};  

after qr/^set_intel_.*/ => sub { 
    my $self = shift; 

    $self->set_pkg($self->intel->pkg_opt); 
};  

after qr/^set_kokkos_.*/ => sub { 
    my $self = shift; 

    $self->set_pkg($self->kokkos->pkg_opt); 
};  



sub _get_opts { 
    return qw(inp log var kokkos_thr suffix pkg)
}

__PACKAGE__->meta->make_immutable;

1
