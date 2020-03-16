package HPC::Types::Sched::Slurm; 

use MooseX::Types::Moose qw(Str Int); 
use MooseX::Types -declare => [qw(
    Name Partition Comment
    Nodes Tasks Tasks_per_Node Cpus_per_Task Ngpus Time
    Error Output)]; 

subtype Name          , as Str, where {/^#SBATCH/ };
subtype Partition     , as Str, where {/^#SBATCH/ };
subtype Comment       , as Str, where {/^#SBATCH/ };
subtype Nodes         , as Str, where {/^#SBATCH/ };
subtype Tasks         , as Str, where {/^#SBATCH/ }; 
subtype Cpus_per_Task , as Str, where {/^#SBATCH/ };
subtype Tasks_per_Node, as Str, where {/^#SBATCH/ };
subtype Ngpus         , as Str, where {/^#SBATCH/ };
subtype Time          , as Str, where {/^#SBATCH/ };
subtype Error         , as Str, where {/^#SBATCH/ };
subtype Output        , as Str, where {/^#SBATCH/ };

coerce Name           , from Str, via { "#SBATCH --job-name=$_"        };
coerce Partition      , from Str, via { "#SBATCH --partition=$_"       }; 
coerce Comment        , from Str, via { "#SBATCH --comment=$_"         }; 
coerce Nodes          , from Str, via { "#SBATCH --nodes=$_"           }; 
coerce Tasks          , from Str, via { "#SBATCH --ntasks=$_"          }; 
coerce Cpus_per_Task  , from Str, via { "#SBATCH --cpus-per-task=$_"   }; 
coerce Tasks_per_Node , from Str, via { "#SBATCH --ntasks-per-node=$_" }; 
coerce Ngpus          , from Str, via { "#SBATCH --gres=gpu:$_"        }; 
coerce Time           , from Str, via { "#SBATCH --time=$_"            }; 
coerce Error          , from Str, via { "#SBATCH --error=$_"           }; 
coerce Output         , from Str, via { "#SBATCH --output=$_"          }; 
