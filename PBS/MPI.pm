package HPC::PBS::MPI; 

use Moose::Role; 
use Moose::Util::TypeConstraints;

use HPC::MPI::Lib; 

subtype 'MPI' 
    => as 'Object'
    => where { $_->isa('HPC::MPI::Lib') }; 

coerce 'MPI'
    => from 'Str'
    => via {  
        my ($lib, $version) = split /\//, $_; 
        my $role = join '::', 'HPC', 'MPI', uc($lib); 
        HPC::MPI::Lib->with_traits($role)->new(
            lib     => $lib, 
            version => $version, 
        )
    }; 

has 'mpi' => (
    is        => 'rw',
    isa       => 'MPI',
    init_arg  => undef,
    coerce    => 1,
    predicate => 'has_mpi', 
    writer    => '_load_mpi', 
    clearer   => '_unload_mpi', 
    handles   => { 
        mpiexe => 'mpirun', 
        mpilib => 'lib',
    } 
); 

1
