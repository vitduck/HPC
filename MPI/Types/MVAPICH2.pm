package HPC::MPI::Types::MVAPICH2; 

use IO::File; 
use MooseX::Types::Moose qw(Str Int ArrayRef HashRef);  

use MooseX::Types -declare => [qw(OMP_MVAPICH2 ENV_MVAPICH2)]; 

subtype OMP_MVAPICH2, as Str, where { /^OMP_NUM_THREADS/ }; 
subtype ENV_MVAPICH2, as ArrayRef; 

coerce OMP_MVAPICH2,  from     Int, via { 'OMP_NUM_THREADS='.$_ }; 
coerce ENV_MVAPICH2,  from HashRef, via {  my $env = $_; [ map $_.'='.$env->{$_}, sort keys $env->%* ] }; 

1
