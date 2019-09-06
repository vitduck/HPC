package HPC::App::Lammps;

use Moose; 
use Text::Tabs; 
use MooseX::Types::Moose qw(ArrayRef); 
use namespace::autoclean; 

use HPC::App::Lammps::Opt; 
use HPC::App::Lammps::Omp; 
use HPC::App::Lammps::Gpu; 
use HPC::App::Lammps::Intel; 
use HPC::App::Lammps::Kokkos; 
use HPC::App::Types::Lammps qw(
    Suffix Kokkos_OMP Inp Log Var Pkg OPT OMP GPU INTEL KOKKOS
); 

with qw( HPC::Debug::Data HPC::App::Base );  

has _opts => ( 
    is       => 'ro', 
    isa      => ArrayRef, 
    traits   => ['Array'],
    init_arg => undef,
    default  => sub { [qw(suffix inp log var pkg kokkos_omp)] }, 
    handles  => { _list_opts => 'elements' }
); 

has _pkgs => ( 
    is       => 'ro', 
    isa      => ArrayRef, 
    traits   => ['Array'],
    init_arg => undef,
    default  => sub { [qw(opt omp gpu intel kokkos)] },
    handles  => { _list_pkgs => 'elements' }
); 

has 'suffix' => (
    is        => 'rw',
    isa       => Suffix,
    coerce    => 1, 
    predicate => '_has_suffix', 
    writer    => 'set_suffix',  
); 

has 'kokkos_omp' => ( 
    is        => 'rw', 
    isa       => Kokkos_OMP, 
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_kokkos_omp', 
    writer    => 'set_kokkos_omp',   
    default   => 1, 
); 

has 'inp' => ( 
    is        => 'rw',
    isa       => Inp, 
    coerce    => 1, 
    predicate => '_has_inp',
    writer    => 'set_inp', 
); 

has 'log' => ( 
    is        => 'rw',
    isa       => Log, 
    coerce    => 1, 
    predicate => '_has_log',
    writer    => 'set_log', 
    default   => 'md.log'
); 

has 'var' => ( 
    is        => 'rw',
    isa       => Var, 
    coerce    => 1, 
    predicate => '_has_var',
    writer    => 'set_var',
); 

has 'pkg' => ( 
    is        => 'rw', 
    isa       => Pkg, 
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_pkg', 
    writer    => '_set_pkg',
    clearer   => '_reset_pkg',
    default   => sub { [] }, 
); 

has opt => ( 
    is        => 'rw',
    isa       => OPT,
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_opt',
    clearer   => '_clear_opt',
    default   => sub { HPC::App::Lammps::Opt->new }, 
    trigger   => sub { shift->set_suffix('opt')   }
); 

has omp => ( 
    is        => 'rw',
    isa       => OMP, 
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_omp',
    clearer   => '_clear_omp', 
    default   => sub { HPC::App::Lammps::Omp->new }, 
    trigger   => sub { shift->set_suffix('omp') }, 
    handles   => { 
        set_omp_nthreads => 'set_nthreads', 
        set_omp_neigh    => 'set_neigh',
    }, 
); 

has gpu => (
    is        => 'rw',
    isa       => GPU,
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_gpu',
    clearer   => '_clear_gpu', 
    default   => sub { HPC::App::Lammps::Gpu->new }, 
    trigger   => sub { shift->set_suffix('gpu')   }, 
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
    } 
); 

has intel => ( 
    is        => 'rw',
    isa       => INTEL,
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_intel',
    clearer   => '_clear_intel', 
    default   => sub { HPC::App::Lammps::Intel->new }, 
    trigger   => sub { shift->set_suffix('intel')   }, 
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
    isa       => KOKKOS,
    coerce    => 1, 
    lazy      => 1, 
    predicate => '_has_kokkos',
    clearer   => '_clear_kokkos', 
    default   => sub { HPC::App::Lammps::Kokkos->new }, 
    trigger   => sub { 
        my $self = shift; 

        $self->set_suffix('kk'); 
        $self->set_kokkos_omp(1); 
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
    }
); 

sub get_pkg { 
    my $self = shift; 

    for my $pkg ($self->_list_pkgs) { 
        my $has_pkg = "_has_$pkg"; 

        return $pkg if $self->$has_pkg
    } 
} 

sub load_pkg { 
    my ($self, $pkg, $opt) = @_; 

    $self->$pkg( $opt ? $opt : {} ); 
}

sub unload_pkg { 
    my ($self, $name) = @_; 

    my $loaded_pkg = $self->get_pkg; 

    if ($loaded_pkg) {  
        my $clear_loaded_pkg = "_clear_$loaded_pkg"; 
        $self->$clear_loaded_pkg; 
        $self->_reset_pkg; 
    } 
} 

sub cmd {
    $tabstop = 4;
    my $self = shift;
    my @opts = (); 

    # if package is loaded 
    my $pkg = $self->get_pkg; 
    $self->_set_pkg($self->$pkg->pkg_opt) if $pkg; 

    # pad the commandline with tab
    for my $opt ($self->_list_opts) {
        my $has_opt = "_has_$opt";
        push @opts, "\t" . $self->$opt if $self->$has_opt and $self->$opt ne ''
    }

    return [$self->bin, expand(sort @opts)]
}

__PACKAGE__->meta->make_immutable;

1
