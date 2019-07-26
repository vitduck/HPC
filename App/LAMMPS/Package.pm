package HPC::App::LAMMPS::Package; 

use Moose::Role;  
use HPC::App::LAMMPS::Types qw/Suffix Pkg/; 

requires '_build_package';  

has 'suffix' => ( 
    is      => 'rw',
    isa     => Suffix,
    coerce  => 1, 
    writer  => 'set_suffix', 
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

1
