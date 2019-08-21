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
            map { $_.'='.$env->{$_} } keys $env->%* ) 
    }; 

subtype MCA_OPENMPI,
    as Str, 
    where { /\-\-mca/ }; 

coerce MCA_OPENMPI, 
    from HashRef, 
    via { 
        my $mca = $_;  

        '--mca '.join(' ', map { $_.' '.$mca->{$_} } sort keys $mca->%*)    
    }; 

1
