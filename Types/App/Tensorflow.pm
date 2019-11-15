package HPC::Types::App::Tensorflow;  

use MooseX::Types::Moose qw/Str Int/; 
use MooseX::Types -declare => [qw(Cnn)]; 

subtype Cnn, as   Str, where { /^python/     }; 
coerce  Cnn, from Str, via   { 'python ' .$_ }; 

1
