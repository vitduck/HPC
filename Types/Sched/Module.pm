package HPC::Types::Sched::Module; 

use MooseX::Types::Moose qw(Str ArrayRef); 
use MooseX::Types -declare => ['Module']; 

use File::Slurp; 
use JSON::PP; 

subtype Module, as   ArrayRef; 
coerce Module,  from Str, via { 
    # parse json config file
    my $config = read_file("$ENV{HOME}/.hpcrc");
    my $jason  = decode_json($config);

    # example: knl/intel
    my @presets = split /\//, $_; 

    return [
        map { 
              ref $jason->{$_} eq ref [] 
              ? $jason->{$_}->@* 
              : $jason->{$_} 
        } @presets 
    ]
};  

1
