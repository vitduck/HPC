package HPC::Benchmark::LAMMPS;

use Moose; 
use MooseX::Types::Moose qw/Object Str Undef/; 

use HPC::App::LAMMPS::OPT; 
use HPC::App::LAMMPS::OMP; 
use HPC::App::LAMMPS::INTEL; 
use HPC::App::LAMMPS::KOKKOS; 
use HPC::App::LAMMPS::Types qw/Inp Log Var ACC/; 

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

has 'pkg' => ( 
    is        => 'rw',
    isa       => ACC,
    coerce    => 1, 
    writer    => 'enable_pkg', 
    clearer   => 'disable_pkg', 
    handles   => { 
        set_pkg_opt => 'set_opt'
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
        grep $self->$_, qw/bin inp log var/ 
    ); 

    # pkg opts 
    push @opts, $self->pkg->cmd if $self->pkg; 


    return join(' ', @opts)
} 

__PACKAGE__->meta->make_immutable;

1
