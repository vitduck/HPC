package HPC::MPI::Types; 

use IO::File; 
use MooseX::Types -declare => [qw/MPI MPILIB/]; 
use MooseX::Types::Moose qw/Str Int Object HashRef/;  

class_type MPILIB, { class => 'HPC::MPI::Lib' }; 

subtype MPI, 
    as MPILIB; 

coerce  MPI, 
    from Str, 
    via {  
        my ($module, $version) = split /\//, $_; 

        my $lib = $1 if $module =~ /(impi|openmpi|mvapich2)/;

        'HPC::MPI::Lib'->new( 
            module  => $module, 
            version => $version
        ); 
    }; 

1
