package HPC::App::Types::Numa;  

use MooseX::Types -declare => [qw(Memkind Membind Preferred)];  
use MooseX::Types::Moose qw(Str HashRef);  

enum Memkind, [qw(mcdram ddr4)]; 

subtype Membind,   as Str, where { /^\-m/ }; 
subtype Preferred, as Str, where { /^\-p/ }; 

coerce  Membind,   from Memkind, via { $_ eq 'mcdram' ? '-m 1' : '-m 0' }; 
coerce  Preferred, from Memkind, via { $_ eq 'mcdram' ? '-p 1' : '-p 0' }; 

1