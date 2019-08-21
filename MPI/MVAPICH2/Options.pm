package HPC::MPI::MVAPICH2::Options; 

use IO::File; 
use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  

use MooseX::Types -declare => [qw(OMP_MVAPICH2 ENV_MVAPICH2)]; 

subtype OMP_MVAPICH2,
    as Str, 
    where { /^OMP_NUM_THREADS/ }; 

coerce OMP_MVAPICH2, 
    from Int, 
    via { 'OMP_NUM_THREADS='.$_ }; 

subtype ENV_MVAPICH2,
    as Str; 

coerce ENV_MVAPICH2, 
    from HashRef, 
    via { 
        my $env = $_;  

        join(' ', map { $_.'='.$env->{$_} } sort keys $env->%*) 
    }; 

1
