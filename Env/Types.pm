package HPC::Env::Types;  

use MooseX::Types -declare => [qw/SRC_MPI SRC_MKL/]; 
use MooseX::Types::Moose qw/Str/; 

subtype SRC_MKL, 
    as Str, 
    where { /^\./ }; 

coerce SRC_MKL, 
    from Str, 
    via { 
        my ($version) = (split /\//, $_)[1]; 

        return ". /apps/compiler/intel/$version/mkl/bin/mklvars.sh intel64"
    };  

subtype SRC_MPI, 
    as Str, 
    where { $_ =~ /^\./ }; 

coerce SRC_MPI, 
    from Str, 
    via { 
        my ($version) = (split /\//, $_)[1]; 

        return ". /apps/compiler/intel/$version/impi/2018.3.222/intel64/bin/mpivars.sh" 
    }; 

1
