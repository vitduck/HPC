package HPC::App::LAMMPS;

use Moose; 
use MooseX::Types::Moose qw/Object Str Undef/; 

use HPC::App::LAMMPS::OPT; 
use HPC::App::LAMMPS::OMP; 
use HPC::App::LAMMPS::INTEL; 
use HPC::App::LAMMPS::KOKKOS; 
use HPC::App::LAMMPS::Types qw/Inp Log Var/; 

with 'HPC::Debug::Data', 
     'HPC::App::Base'; 

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

has 'pkg' => ( 
    is        => 'rw',
    isa      => Str|Undef,
    init_arg => undef, 
    lazy     => 1, 
    clearer =>'_reset_pkg', 
    default  => sub { 
        my $self = shift; 

        return 
            $self->has_opt    ? $self->opt->cmd    :  
            $self->has_omp    ? $self->omp->cmd    :  
            $self->has_intel  ? $self->intel->cmd  :  
            $self->has_kokkos ? $self->kokkos->cmd :  
            undef
    },  
); 

for my $pkg (qw/opt omp intel kokkos/) { 
    has "$pkg" => (  
        is        => 'rw',
        isa       => 'HPC::App::LAMMPS::'.uc($pkg), 
        init_arg  => undef,
        lazy      => 1, 
        reader    => "load_$pkg", 
        clearer   => "unload_$pkg", 
        predicate => "has_$pkg", 
        default   => sub { ('HPC::App::LAMMPS::'.uc($pkg))->new }, 
        handles   => { "set_$pkg" => 'set_opt' }
    ) ;  
}

after qr/^set_(opt|omp|intel|kokkos)/ => sub { 
    my $self = shift; 

    $self->_reset_pkg
}; 

sub cmd { 
    my $self = shift; 
    
    my @opts = 
        map  $self->$_, 
        grep $self->$_, qw/inp log var pkg/; 

    return join(' ', $self->bin, @opts)
} 

__PACKAGE__->meta->make_immutable;

1
