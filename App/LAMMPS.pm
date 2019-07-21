package HPC::App::LAMMPS;

use Moose; 
use MooseX::Types::Moose qw/Object Str/; 

use HPC::App::LAMMPS::OPT; 
use HPC::App::LAMMPS::OMP; 
use HPC::App::LAMMPS::INTEL; 
use HPC::App::LAMMPS::KOKKOS; 
use HPC::App::LAMMPS::Types qw/Inp Log Var Acc/; 

with 'HPC::App::Base'; 

has 'inp' => ( 
    is      => 'rw',
    isa     => Inp, 
    coerce  => 1, 
    writer  => 'set_inp', 
); 

has 'log' => ( 
    is      => 'rw',
    isa     => Log, 
    coerce  => 1, 
    writer  => 'set_log', 
); 

has 'var' => ( 
    is       => 'rw',
    isa     => Var, 
    coerce  => 1, 
    writer  => 'set_var', 
); 

has 'pkg' => (  
    is       => 'rw',
    isa      => Acc,
    init_arg => undef,
    coerce   => 1, 
    clearer  => 'unload_pkg'
); 

sub cmd { 
    my $self = shift; 
    
    # for -inp, -log, and -var options
    my @opts = 
        map  $self->$_, 
        grep $self->$_, qw/inp log var/; 

    # for -package options 
    push @opts, $self->pkg->cmd if $self->pkg; 

    return join(' ', $self->bin, @opts)
} 

__PACKAGE__->meta->make_immutable;

1
