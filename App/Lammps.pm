package HPC::App::Lammps;

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose qw(ArrayRef); 
use namespace::autoclean; 

use HPC::App::Lammps::Opt; 
use HPC::App::Lammps::Omp; 
use HPC::App::Lammps::Gpu; 
use HPC::App::Lammps::Intel; 
use HPC::App::Lammps::Kokkos; 
use HPC::App::Types::Lammps qw(
    Suffix Kokkos_Thr Inp Log Var Pkg 
    Pkg_Opt Pkg_Omp Pkg_Gpu Pkg_Intel Pkg_Kokkos
); 

with qw(
    HPC::Share::Cmd
    HPC::Debug::Data 
);  

has 'suffix' => (
    is        => 'rw',
    isa       => Suffix,
    traits    => ['Chained'],
    coerce    => 1, 
    clearer   => '_unset_suffix',
    predicate => '_has_suffix', 
); 

has 'kokkos_thr' => ( 
    is        => 'rw', 
    isa       => Kokkos_Thr, 
    traits    => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    clearer   => '_unset_kokkos_thr', 
    predicate => '_has_kokkos_thr', 
    default   => 1, 
); 

has 'inp' => ( 
    is        => 'rw',
    isa       => Inp, 
    traits    => ['Chained'],
    coerce    => 1, 
    predicate => '_has_inp',
); 

has 'log' => (
    is        => 'rw',
    isa       => Log, 
    traits    => ['Chained'],
    coerce    => 1, 
    predicate => '_has_log',
    default   => 'log.lammps'
); 

has 'var' => ( 
    is        => 'rw',
    isa       => Var, 
    traits    => ['Chained'],
    coerce    => 1, 
    predicate => '_has_var',
); 

has 'pkg' => ( 
    is        => 'rw', 
    isa       => Pkg, 
    traits    => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    clearer   => '_unset_pkg', 
    predicate => '_has_pkg', 
    default   => sub { [] }, 
); 

# accelerator package
has opt => ( 
    is        => 'rw',
    isa       => Pkg_Opt,
    traits    => ['Chained'], 
    coerce    => 1, 
    lazy      => 1, 
    clearer   => 'unset_opt',
    predicate => '_has_opt',
    default   => sub {{}}, 
    trigger   => sub { shift->suffix('opt') }
); 

has omp => ( 
    is        => 'rw',
    isa       => Pkg_Omp, 
    traits    => ['Chained'], 
    coerce    => 1, 
    lazy      => 1, 
    clearer   => 'unset_omp', 
    predicate => '_has_omp',
    default   => sub { {} }, 
    trigger   => sub { shift->suffix('omp') }, 
); 

has gpu => (
    is        => 'rw',
    isa       => Pkg_Gpu,
    traits    => ['Chained'], 
    coerce    => 1, 
    lazy      => 1, 
    clearer   => 'unset_gpu', 
    predicate => '_has_gpu',
    default   => sub { {} }, 
    trigger   => sub { shift->suffix('gpu') }, 
); 

has intel => ( 
    is        => 'rw',
    isa       => Pkg_Intel,
    traits    => ['Chained'], 
    coerce    => 1, 
    lazy      => 1, 
    clearer   => 'unset_intel',
    predicate => '_has_intel',
    default   => sub { {} }, 
    trigger   => sub { shift->suffix('intel') }, 
); 

has kokkos => ( 
    is        => 'rw',
    isa       => Pkg_Kokkos,
    traits    => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    clearer   => 'unset_kokkos',
    predicate => '_has_kokkos',
    default   => sub { {} }, 
    trigger   => sub { shift->suffix('kk')->kokkos_thr(1) }
); 

after qr/^unset_(opt|omp|gpu|intel|kokkos)/ => sub { 
    my $self = shift; 

    $self->_unset_suffix; 
    $self->_unset_kokkos_thr; 
    $self->_unset_pkg; 
}; 

around 'cmd' => sub { 
    my ($cmd, $self) = @_; 

    for my $pkg (qw(omp gpu intel kokkos)) { 
        my $has = "_has_$pkg"; 

        $self->pkg($self->$pkg->pkg_opt) if $self->$has
    } 

    return $self->$cmd; 
}; 

sub _get_opts { 
    return qw(inp log var kokkos_thr suffix pkg)
}

__PACKAGE__->meta->make_immutable;

1
