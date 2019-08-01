package HPC::Benchmark::LAMMPS;

use Moose; 
use MooseX::Types::Moose qw/Object Str Undef/; 

use HPC::App::LAMMPS::OPT; 
use HPC::App::LAMMPS::OMP; 
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
        set_kokkos_opts   => 'set_opts'
    }
); 

for my $pkg (qw(opt omp gpu intel)) { 
    has $pkg => ( 
        is        => 'rw',
        isa       => 'HPC::App::LAMMPS::'.uc($pkg),
        init_arg  => undef,
        lazy      => 1, 
        reader    => "load_$pkg", 
        clearer   => "unload_$pkg", 
        predicate => "has_$pkg",
        default   => sub { ('HPC::App::LAMMPS::'.uc($pkg))->new }, 
        handles   => { 
            "set_${pkg}_suffix" => 'set_suffix',  
            "set_${pkg}_opts"   => 'set_opts'
        }
    )
} 

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

        push @opts, $self->$pkg->cmd if $self->$predicate; 
    }

    return join(' ', @opts)
} 

__PACKAGE__->meta->make_immutable;

1
