package HPC::Types::Sched::Slurm; 

use MooseX::Types::Moose qw(Str Int); 
use MooseX::Types -declare => [
    qw( Name Partition Comment
        Nodes Tasks Tasks_per_Node Cpus_per_Task Mem Ngpus Time 
        Error Output
    )
]; 

subtype Name, 
    as Str, 
    where {/^#SBATCH/ };
coerce Name, 
    from Str, 
    via { "#SBATCH --job-name=$_" };

subtype Partition, 
    as Str, 
    where {/^#SBATCH/ };
coerce Partition, 
    from Str, 
    via { "#SBATCH --partition=$_" }; 

subtype Comment, 
    as Str, where {/^#SBATCH/ };
coerce Comment, 
    from Str, 
    via { "#SBATCH --comment=$_" };

subtype Nodes, 
    as Str, 
    where {/^#SBATCH/ };
coerce Nodes, 
    from Str, 
    via { "#SBATCH --nodes=$_" }; 

subtype Tasks, 
    as Str, 
    where {/^#SBATCH/ }; 
coerce Tasks, 
    from Str, 
    via { "#SBATCH --ntasks=$_"  }; 

subtype Tasks_per_Node, 
    as Str, 
    where {/^#SBATCH/ };
coerce Tasks_per_Node, 
    from Str, 
    via { "#SBATCH --ntasks-per-node=$_" }; 

subtype Cpus_per_Task, 
    as Str, 
    where {/^#SBATCH/ };
coerce Cpus_per_Task, 
    from Str, 
    via { "#SBATCH --cpus-per-task=$_" }; 

subtype Mem, 
    as Str, 
    where {/^#SBATCH/ };
coerce Mem, 
    from Str, 
    via { "#SBATCH --mem=$_" }; 

subtype Ngpus, 
    as Str, 
    where {/^#SBATCH/ };
coerce Ngpus, 
    from Str, 
    via { "#SBATCH --gres=gpu:$_" }; 

subtype Time, 
    as Str, 
    where {/^#SBATCH/ };
coerce Time, 
    from Str, 
    via { "#SBATCH --time=$_" }; 

subtype Error, 
    as Str, 
    where {/^#SBATCH/ };
coerce Error, 
    from Str, 
    via { "#SBATCH --error=$_" }; 

subtype Output, 
    as Str, 
    where {/^#SBATCH/ };
coerce Output, 
    from Str, via { "#SBATCH --output=$_" }; 

1
