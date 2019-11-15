package HPC::Types::Sched::Module; 

use MooseX::Types::Moose qw/Str ArrayRef/; 
use MooseX::Types -declare => [qw(Module)]; 

my %preset = (
        knl   => 'craype-mic-knl',
        skl   => 'craype-x86-skylake', 
        intel => [qw(intel/18.0.3 impi/18.0.3 vtune/18.0.3)], 
        cray  => [qw(cce/8.6.3 PrgEnv-cray/1.0.2 cray-impi/1.1.4 cray-libsci/17.09.1 cray-fftw_impi/3.3.6.2)],
        gnu   => [qw(gcc/8.3.0 openmpi/3.1.0 lapack/3.7.0 fftw_mpi/3.3.7)]
); 

subtype Module, 
    as ArrayRef; 

coerce Module,  
    from Str, 
    via { 
        my ($cpu, $compiler) = split /\//, $_; 

        [$preset{$cpu}, $preset{$compiler}->@*]
    };  

1
