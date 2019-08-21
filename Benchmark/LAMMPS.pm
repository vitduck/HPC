package HPC::Benchmark::LAMMPS;

use Moose; 
use MooseX::Types::Moose qw/Object Str Undef/; 

use HPC::App::LAMMPS::OPT; 
use HPC::App::LAMMPS::OMP; 
use HPC::App::LAMMPS::GPU;
use HPC::App::LAMMPS::INTEL; 
use HPC::App::LAMMPS::KOKKOS; 
use HPC::App::LAMMPS::Types qw/Inp Log Var/; 

with 'HPC::Debug::Data', 
     'HPC::Benchmark::Base'; 

has 'inp' => ( 
    is     => 'rw',
    isa    => Inp, 
    coerce => 1, 
    writer => 'set_inp', 
); 

has 'log' => ( 
    is     => 'rw',
    isa    => Log, 
    coerce => 1, 
    writer => 'set_log', 
); 

has 'var' => ( 
    is     => 'rw',
    isa    => Var, 
    coerce => 1, 
    writer => 'set_var', 
); 

# kokkos: thread number is set through -k option
has kokkos => ( 
    is        => 'rw',
    isa       => 'HPC::App::LAMMPS::KOKKOS',
    init_arg  => undef,
    lazy      => 1, 
    reader    => 'load_kokkos', 
    clearer   => 'unload_kokkos',
    predicate => 'has_kokkos',
    default   => sub { HPC::App::LAMMPS::KOKKOS->new }, 
    handles   => { 
         set_kokkos        => 'set_kokkos',
         set_kokkos_suffix => 'set_suffix',  
         set_kokkos_opts   => 'set_opts', 
        list_kokkos_cmd    => 'list_pkg_cmd'
    }
); 

has opt => ( 
    is        => 'rw',
    isa       => 'HPC::App::LAMMPS::OPT',
    init_arg  => undef,
    lazy      => 1, 
    reader    => 'load_opt', 
    clearer   => 'unload_opt',
    predicate => 'has_opt',
    default   => sub { HPC::App::LAMMPS::KOKKOS->new }, 
    handles   => { 
         set_opt_suffix => 'set_suffix',  
         set_opt_opts   => 'set_opts', 
        list_opt_cmd    => 'list_pkg_cmd'
    }
); 

has omp => ( 
    is        => 'rw',
    isa       => 'HPC::App::LAMMPS::OMP',
    init_arg  => undef,
    lazy      => 1, 
    reader    => 'load_omp', 
    clearer   => 'unload_omp',
    predicate => 'has_omp',
    default   => sub { HPC::App::LAMMPS::KOKKOS->new }, 
    handles   => { 
         set_omp_suffix => 'set_suffix',  
         set_omp_opts   => 'set_opts', 
        list_omp_cmd    => 'list_pkg_cmd'
    }
); 

has intel => ( 
    is        => 'rw',
    isa       => 'HPC::App::LAMMPS::INTEL',
    init_arg  => undef,
    lazy      => 1, 
    reader    => 'load_intel', 
    clearer   => 'unload_intel',
    predicate => 'has_intel',
    default   => sub { HPC::App::LAMMPS::KOKKOS->new }, 
    handles   => { 
         set_intel_suffix => 'set_suffix',  
         set_intel_opts   => 'set_opts', 
        list_intel_cmd    => 'list_pkg_cmd'
    }
); 

has gpu => ( 
    is        => 'rw',
    isa       => 'HPC::App::LAMMPS::GPU',
    init_arg  => undef,
    lazy      => 1, 
    reader    => 'load_gpu', 
    clearer   => 'unload_gpu',
    predicate => 'has_gpu',
    default   => sub { HPC::App::LAMMPS::KOKKOS->new }, 
    handles   => { 
         set_gpu_suffix => 'set_suffix',  
         set_gpu_opts   => 'set_opts', 
        list_gpu_cmd    => 'list_pkg_cmd'
    }
); 

sub cmd { 
    my $self = shift; 
    my @opts = (); 

    # application performance snapshot
    push @opts, 'aps' if $self->aps; 
    
    # lmp opts
    push @opts, (        
        map  $self->$_, 
        grep $self->$_, qw(bin inp log var)
    ); 

    # pkg opts 
    for my $pkg (qw(opt omp gpu intel kokkos)) { 
        my $predicate = "has_$pkg"; 
        my $pkg_cmd   = "list_${pkg}_cmd"; 

        push @opts, $self->$pkg_cmd if $self->$predicate; 
    }

    return join(' ', @opts)
} 

__PACKAGE__->meta->make_immutable;

1
