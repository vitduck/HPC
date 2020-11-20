package HPC::Types::Sched::Pbs; 

use MooseX::Types::Moose qw(HashRef); 
use MooseX::Types -declare => [qw(Option)]; 

use experimental qw(switch smartmatch); 

subtype Option, 
    as HashRef, 
    where { grep /^#PBS/, values $_->%* };   

coerce Option, 
    from HashRef, 
    via { 
        my $opt     = $_; 
        my %pbs_opt = (); 

        for my $key ( keys $opt->%*) { 
            given ($key) { 
                when ('export'  ) { $pbs_opt{ $key } = '#PBS -V'                 }
                when ('project' ) { $pbs_opt{ $key } = '#PBS -P '.$opt->{ $key } }
                when ('name'    ) { $pbs_opt{ $key } = '#PBS -N '.$opt->{ $key } }
                when ('app'     ) { $pbs_opt{ $key } = '#PBS -A '.$opt->{ $key } }
                when ('queue'   ) { $pbs_opt{ $key } = '#PBS -q '.$opt->{ $key } }
                when ('stderr'  ) { $pbs_opt{ $key } = '#PBS -e '.$opt->{ $key } }
                when ('stdour'  ) { $pbs_opt{ $key } = '#PBS -o '.$opt->{ $key } }
                when ('walltime') { $pbs_opt{ $key } = '#PBS -l '.$opt->{ $key } }

                when (/resource/) { 
                    $pbs_opt{ $key } = '#PBS -l select='.(
                        ref $opt->{ $key } eq 'ARRAY'   
                            ? join('+', $opt->{ $key }->@*) 
                            : $opt->{ $key } 
                    ) 
                }
            } 
        } 

        return { %pbs_opt }
    }; 

1
