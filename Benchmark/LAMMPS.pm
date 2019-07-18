package HPC::Benchmark::LAMMPS;

use Moose; 

with 'HPC::Benchmark::Base'; 

has 'sf' => ( 
    is        => 'rw', 
    isa       => 'Str', 
    predicate => 'has_sf'
); 

has 'k' => ( 
    is        => 'rw', 
    isa       => 'Str', 
    predicate => 'has_k'
); 

has 'pk' => ( 
    is        => 'rw', 
    isa       => 'Str', 
    predicate => 'has_pk'
); 

# after [qw(inp out bin k sf pk)] => sub { 
    # my $self = shift; 

    # $self->_reset_cmd; 
# }; 

sub _build_cmd { 
    my $self = shift; 
    my @opts = (); 

    for my $attr (qw(inp out k sf pk)) { 
        my $predicate = "has_$attr"; 
            
        if ( $self->$predicate ) {  
            push @opts, "-$attr", $self->$attr; 
        }
    }

    return join ' ', $self->bin, @opts
} 

__PACKAGE__->meta->make_immutable;

1
