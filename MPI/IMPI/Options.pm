package HPC::MPI::IMPI::Options; 

use IO::File; 
use MooseX::Types::Moose qw(Undef Str Int ArrayRef HashRef);  
use MooseX::Types -declare => [qw(ENV_IMPI)]; 

subtype ENV_IMPI,
    as Str; 

coerce ENV_IMPI, 
    from HashRef, 
    via { 
        my $env = $_;  

        join(' ', 
            map { ('-env', $_) }
            map { $_.'='.$env->{$_} } keys $env->%* ) 
    }; 

1
