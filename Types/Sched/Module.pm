package HPC::Types::Sched::Module; 

use File::Slurp; 
use JSON::PP; 
use MooseX::Types::Moose qw/Str ArrayRef/; 
use MooseX::Types -declare => [qw(Module)]; 

subtype Module, 
    as ArrayRef; 

coerce Module,  
    from Str, 
    via { 
        # parse json config file
        my $config = read_file("$ENV{HOME}/.modulerc");
        my $preset = decode_json($config);

        # example: knl/intel
        my ($cpu, $compiler) = split /\//, $_; 

        [$preset->{$cpu}, $preset->{$compiler}->@*]
    };  

1
