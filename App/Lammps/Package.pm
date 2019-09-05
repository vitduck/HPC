package HPC::App::LAMMPS::Package; 

use Moose::Role;  
use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/Str ArrayRef/; 
use HPC::App::LAMMPS::Types qw/Suffix Pkg/; 

has 'suffix' => (
    is      => 'rw',
    isa     => Suffix,
    coerce  => 1, 
    writer  => 'set_suffix',  
    trigger => sub { shift->_reset_cmd }
); 

has 'package' => (
    is       => 'rw', 
    isa      => Pkg, 
    init_arg => undef, 
    coerce   => 1, 
);  

has 'cmd' => ( 
    is       => 'rw', 
    isa      => ArrayRef, 
    traits   => ['Array'], 
    init_arg => undef, 
    lazy     => 1, 
    clearer  => '_reset_cmd',
    builder  => '_build_cmd', 
    handles  => { list_pkg_cmd => 'elements' }
);  

has '_opt' => ( 
    is       => 'ro', 
    isa      => ArrayRef[Str], 
    traits   => ['Array'], 
    init_arg => undef,
    default  => sub {[]}, 
    handles  => { 
        list_pkg_opts => 'elements'
    } 
); 

sub _build_cmd { 
    my $self = shift; 

    return [grep $_, $self->suffix, $self->package($self->options)]
} 

# emulate hash delegation
sub set_opts { 
    my ($self, @opts) = @_; 

    while ( my ($attr, $value) = splice @opts, 0, 2) { 
        #kokkos
        $attr =~ s/\//_/; 

        $self->$attr($value); 
    } 
} 

sub options { 
    my $self = shift;  
    my @opts = (); 

    for my $opt ( $self->list_pkg_opts ) { 
        my $predicate = "has_$opt"; 

        push @opts, $opt, $self->$opt if $self->$predicate
    } 

    return [@opts]; 
} 

1
