package HPC::MPI::OPENMPI::Options; 

use IO::File; 
use MooseX::Types::Moose qw(Undef Str Int HashRef);  
use MooseX::Types -declare => [qw(OMP_OPENMPI ENV_OPENMPI MCA_OPENMPI)]; 

subtype OMP_OPENMPI,
    as Str, 
    where { /\-\-map\-by/ }; 

coerce OMP_OPENMPI, 
    from Int, 
    via { '--map-by NUMA:PE='.$_ };

subtype ENV_OPENMPI,
    as Str; 

coerce ENV_OPENMPI, 
    from HashRef, 
    via { 
        my $env = $_;  

        join(' ', 
            map { ('-x', $_) }
            map { $_.'='.$env->{$_} } sort keys $env->%* ) 
    }; 

subtype MCA_OPENMPI,
    as Str; 

coerce MCA_OPENMPI, 
    from HashRef, 
    via { 
        my $mca = $_;  
    
        join(' ', 
            map { ('--mca', $_) }
            map { $_.' '.$mca->{$_} } sort keys $mca->%* ) 
    }; 

1
