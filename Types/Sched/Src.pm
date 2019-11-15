package HPC::Types::Sched::Src; 

use MooseX::Types::Moose qw/Str/; 
use MooseX::Types -declare => [qw/Src_Mpi Src_Mkl/]; 

subtype Src_Mkl, as Str, where { /^\./ }; 
subtype Src_Mpi, as Str, where { /^\./ }; 

coerce Src_Mkl, from Str, via {
    my ($version) = (split /\//, $_)[1]; 

    ". /apps/compiler/intel/$version/mkl/bin/mklvars.sh intel64"
}; 

coerce Src_Mpi, from Str, via {
    my ($version) = (split /\//, $_)[1]; 

    ". /apps/compiler/intel/$version/impi/2018.3.222/intel64/bin/mpivars.sh" 
};

1
