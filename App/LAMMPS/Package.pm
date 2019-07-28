package HPC::App::LAMMPS::Package; 

use Moose::Role;  
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/Str ArrayRef/; 
use HPC::App::LAMMPS::Types qw/Suffix Pkg/; 

has 'name' => (
    is  => 'ro', 
    isa => enum([qw/gpu omp intel kokkos/]), 
); 

has 'suffix' => ( 
    is     => 'rw',
    isa    => Suffix,
    coerce => 1, 
    writer => 'set_suffix', 
); 

has 'arg' => ( 
    is       => 'ro', 
    isa      => Str, 
    init_arg => undef,
    default  => '', 
); 

has 'opts' => ( 
    is       => 'ro', 
    isa      => ArrayRef[Str], 
    traits   => ['Array'], 
    init_arg => undef,
    default  => sub {[]}, 
    handles  => { 
        list_opts => 'elements'
    } 
); 

has 'package' => ( 
    is       => 'rw', 
    isa      => Pkg, 
    init_arg => undef, 
    coerce   => 1, 
    lazy     => 1, 
    builder  => '_build_package', 
    clearer  => '_reset_package'
);  

# emulate hash delegation
sub set_opt { 
    my ($self, @opts) = @_; 

    while ( my ($attr, $value) = splice @opts, 0, 2) { 
        #kokkos
        $attr =~ s/\//_/; 

        $self->$attr($value); 
    } 
} 

sub cmd { 
    my $self = shift; 

    return join ' ', $self->suffix, $self->package; 
} 

sub _build_package { 
    my $self = shift;     
    my @opts = (); 
    my $arg  = $self->arg; 

    push @opts, $self->name;   
    push @opts, $self->$arg if $self->arg; 

    push @opts, 
        map join(' ', $_, $self->$_), 
        grep $self->$_, 
        $self->list_opts; 

    return join(' ', @opts)
} 

1
