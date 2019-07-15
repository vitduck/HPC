package HPC::MPI::Types; 

use Moose::Role; 
use Moose::Util::TypeConstraints;

for my $mpi (qw(IMPI OPENMPI MVAPICH2)) { 
    subtype $mpi,
        => as 'Object'
        => where { $_->isa("HPC::MPI::$mpi") }; 

coerce $mpi,
    => from 'Str'
    => via { 
        my ($module, $version) = split /\//, $_; 
        my $class = "HPC::MPI::$mpi"; 
        $class->new( module  => $module, version => $version )
    }; 
}

1
