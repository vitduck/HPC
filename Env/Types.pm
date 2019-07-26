package HPC::Env::Types;  

use MooseX::Types -declare => [qw/SRC_IMPI SRC_MKL/]; 
use MooseX::Types::Moose qw/Str/; 

subtype SRC_MKL, 
    as Str, 
    where { $_ =~ /^\./ }; 

coerce SRC_MKL, 
    from Str, 
    via { 
        my ($version) = (split /\//, $_)[1]; 

        return 
            join ' ',  
            '.', "/apps/compiler/intel/$version/mkl/bin/mklvars.sh intel64"
    };  

subtype SRC_IMPI, 
    as Str, 
    where { $_ =~ /^\./ }; 

coerce SRC_IMPI, 
    from Str, 
    via { 
        my ($version) = (split /\//, $_)[1]; 

        return 
            join ' ', 
            '.', "/apps/compiler/intel/$version/impi/2018.3.222/intel64/bin/mpivars.sh" 
    }; 

1
