package HPC::MPI::Types; 

use Moose::Role; 
use Moose::Util::TypeConstraints;

for my $mpi (qw(CRAYIMPI IMPI OPENMPI MVAPICH2)) { 
    my $type = "HPC::MPI::Types::$mpi";  

    subtype $type,
        => as 'Object'
        => where { $_->isa("HPC::MPI::$mpi") }; 

    coerce $type,
        => from 'Str'
        => via { 
            my ($module, $version) = split /\//, $_; 
            
            my $class = "HPC::MPI::$mpi"; 
            $class->new( 
                module  => ($module =~ s/-//), # for cray-* module
                version => $version )
        }; 
}

1
