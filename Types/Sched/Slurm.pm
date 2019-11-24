package HPC::Types::Sched::Slurm; 

use MooseX::Types::Moose qw(Str Int); 
use MooseX::Types -declare => [qw(
    Name Partition Comment
    Nodes Tasks Tasks_per_Node Cpus_per_Task Ngpus Time
    Error Output)]; 

subtype Name,           as Str, where {/^#SBATCH -J/                };
subtype Partition,      as Str, where {/^#SBATCH -p/                };
subtype Comment,        as Str, where {/^#SBATCH --comment/         };
subtype Nodes,          as Str, where {/^#SBATCH -N/                };
subtype Tasks         , as Str, where {/^#SBATCH -n/                }; 
subtype Cpus_per_Task,  as Str, where {/^#SBATCH -c/                };
subtype Tasks_per_Node, as Str, where {/^#SBATCH --ntasks-per-node/ };
subtype Ngpus,          as Str, where {/^#SBATCH --gres/            };
subtype Time,           as Str, where {/^#SBATCH -t/                };
subtype Error,          as Str, where {/^#SBATCH -e/                };
subtype Output,         as Str, where {/^#SBATCH -o/                };

coerce Name,           from Str, via { "#SBATCH -J $_"                };
coerce Partition,      from Str, via { "#SBATCH -p $_"                }; 
coerce Comment,        from Str, via { "#SBATCH --comment=$_"         }; 
coerce Nodes,          from Str, via { "#SBATCH -N $_"                }; 
coerce Tasks         , from Str, via { "#SBATCH -n $_"                }; 
coerce Cpus_per_Task,  from Str, via { "#SBATCH -c $_"                }; 
coerce Tasks_per_Node, from Str, via { "#SBATCH --ntasks-per-node=$_" }; 
coerce Ngpus,          from Str, via { "#SBATCH --gres=gpu:$_"        }; 
coerce Time,           from Str, via { "#SBATCH -t $_"                }; 
coerce Error,          from Str, via { "#SBATCH -e $_"                }; 
coerce Output,         from Str, via { "#SBATCH -o $_"                }; 
