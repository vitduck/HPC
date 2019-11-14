package HPC::Plugin::Lammps;

use Moose; 
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::Types::Moose 'ArrayRef'; 
use HPC::Plugin::Lammps::Opt; 
use HPC::Plugin::Lammps::Omp; 
use HPC::Plugin::Lammps::Gpu; 
use HPC::Plugin::Lammps::Intel; 
use HPC::Plugin::Lammps::Kokkos; 
use HPC::Plugin::Types::Lammps qw(
    Suffix Kokkos_Thr Inp Log Var Pkg 
    Pkg_Opt Pkg_Omp Pkg_Gpu Pkg_Intel Pkg_Kokkos ); 
use namespace::autoclean; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd ); 

has 'suffix' => (
    is        => 'rw',
    isa       => Suffix,
    traits    => ['Chained'],
    predicate => '_has_suffix', 
    clearer   => '_unset_suffix',
    coerce    => 1 
); 

has 'kokkos_thr' => ( 
    is        => 'rw', 
    isa       => Kokkos_Thr, 
    traits    => ['Chained'],
    predicate => '_has_kokkos_thr', 
    clearer   => '_unset_kokkos_thr', 
    coerce    => 1, 
    lazy      => 1, 
    default   => 1 
); 

has 'inp' => ( 
    is        => 'rw',
    isa       => Inp, 
    traits    => ['Chained'],
    predicate => '_has_inp',
    coerce    => 1 
); 

has 'log' => (
    is        => 'rw',
    isa       => Log, 
    traits    => ['Chained'],
    predicate => '_has_log',
    coerce    => 1, 
    default   => 'log.lammps' 
); 

has 'var' => ( 
    is        => 'rw',
    isa       => Var, 
    traits    => ['Chained'],
    predicate => '_has_var',
    coerce    => 1 
); 

has 'pkg' => ( 
    is        => 'rw', 
    isa       => Pkg, 
    traits    => ['Chained'],
    predicate => '_has_pkg', 
    clearer   => '_unset_pkg', 
    coerce    => 1, 
    lazy      => 1, 
    default   => sub {[]} 
); 

# accelerator package
has opt => ( 
    is        => 'rw',
    isa       => Pkg_Opt,
    traits    => ['Chained'], 
    predicate => '_has_opt',
    clearer   => 'unset_opt',
    coerce    => 1, 
    lazy      => 1, 
    default   => sub {{}}, 
    trigger   => sub ($self, @) { $self->suffix('opt') }
); 

has omp => ( 
    is        => 'rw',
    isa       => Pkg_Omp, 
    traits    => ['Chained'], 
    predicate => '_has_omp',
    clearer   => 'unset_omp', 
    coerce    => 1, 
    lazy      => 1, 
    default   => sub { {} }, 
    trigger   => sub ($self, @) { $self->suffix('omp') }
); 

has gpu => (
    is        => 'rw',
    isa       => Pkg_Gpu,
    traits    => ['Chained'], 
    predicate => '_has_gpu',
    clearer   => 'unset_gpu', 
    lazy      => 1, 
    coerce    => 1, 
    default   => sub { {} }, 
    trigger   => sub ($self, @) { $self->suffix('gpu') }, 
); 

has intel => ( 
    is        => 'rw',
    isa       => Pkg_Intel,
    traits    => ['Chained'], 
    predicate => '_has_intel',
    clearer   => 'unset_intel',
    coerce    => 1, 
    lazy      => 1, 
    default   => sub {{}}, 
    trigger   => sub ($self, @) { $self->suffix('intel') }, 
); 

has kokkos => ( 
    is        => 'rw',
    isa       => Pkg_Kokkos,
    traits    => ['Chained'],
    predicate => '_has_kokkos',
    clearer   => 'unset_kokkos',
    coerce    => 1, 
    lazy      => 1, 
    default   => sub {{}}, 
    trigger   => sub ($self, @) { $self->suffix('kk')->kokkos_thr(1) }
); 

after qr/^unset_(opt|omp|gpu|intel|kokkos)/ => sub ($self) { 
    $self->_unset_suffix; 
    $self->_unset_kokkos_thr; 
    $self->_unset_pkg; 
}; 

around 'cmd' => sub ($cmd, $self, @) { 
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
