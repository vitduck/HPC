package HPC::Types::Profile::Numa;  

use MooseX::Types::Moose qw(Str HashRef);  
use MooseX::Types -declare => [qw(Memkind Membind Preferred)];  

enum Memkind, [qw(mcdram ddr4)]; 

subtype Membind,   
    as Str, 
    where { /^\-m/ }; 
coerce Membind, 
    from Memkind, 
    via { $_ eq 'mcdram' ? '-m 1' : '-m 0' }; 

subtype Preferred, 
    as Str, 
    where { /^\-p/ }; 
coerce Preferred, 
    from Memkind, 
    via { $_ eq 'mcdram' ? '-p 1' : '-p 0' }; 

1
