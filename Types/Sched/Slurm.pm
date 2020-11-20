package HPC::Types::Sched::Slurm; 

use MooseX::Types::Moose qw(HashRef); 
use MooseX::Types -declare => [qw(Option)]; 

use experimental qw(switch smartmatch);

subtype Option, 
    as HashRef, 
    where { grep /^#SBATCH/, values $_->%* };   

coerce Option, 
    from HashRef, 
    via { 
        my $opt       = $_; 
        my %slurm_opt = (); 

        for my $key ( keys $opt->%*) { 
            given ($key) { 
                when ( 'name'     ) { $slurm_opt{ $key } = '#SBATCH --job-name='       .$opt->{$key}                }
                when ( 'app'      ) { $slurm_opt{ $key } = '#SBATCH --comment='        .$opt->{$key}                }
                when ( 'queue'    ) { $slurm_opt{ $key } = '#SBATCH --partition='      .$opt->{$key}                }
                when ( 'select'   ) { $slurm_opt{ $key } = '#SBATCH --nodes='          .$opt->{$key}                }
                when ( 'mpiprocs' ) { $slurm_opt{ $key } = '#SBATCH --ntasks-per-node='.$opt->{$key}                }
                when ( 'omp'      ) { $slurm_opt{ $key } = '#SBATCH --cpus-per-task='  .$opt->{$key}                }
                when ( 'mem'      ) { $slurm_opt{ $key } = '#SBATCH --mem='            .$opt->{$key}                }
                when ( 'ngpus'    ) { $slurm_opt{ $key } = '#SBATCH --gres=gpu:'       .$opt->{$key}                }
                when ( 'stderr'   ) { $slurm_opt{ $key } = '#SBATCH --error='          .$opt->{$key}                }
                when ( 'stdout'   ) { $slurm_opt{ $key } = '#SBATCH --output='         .$opt->{$key}                }
                when ( 'walltime' ) { $slurm_opt{ $key } = '#SBATCH --time='           .$opt->{$key}                }
                when ( 'nodelist' ) { $slurm_opt{ $key } = '#SBATCH --nodelist='       .join(',', $opt->{$key}->@*) }
                when ( 'exclude'  ) { $slurm_opt{ $key } = '#SBATCH --exclude='        .join(',', $opt->{$key}->@*) }
            } 
        } 

        return { %slurm_opt }
    }; 


1
