package HPC::App::LAMMPS::Types; 

use MooseX::Types -declare => [qw/Inp Log Suffix Kokkos Var Pkg Acc/]; 
use MooseX::Types::Moose qw/Str ArrayRef Object/;

# input
subtype Inp,
    as Str, 
    where { $_ =~/^\-i/ }; 

coerce  Inp, 
    from Str, 
    via { '-i '.$_ }; 

# log
subtype Log, 
    as Str, 
    where { $_ =~/^\-l/ }; 

coerce  Log, 
    from Str, 
    via { '-l '.$_ }; 

# suffix 
subtype Suffix,  
    as Str, 
    where { $_ =~/^\-sf/ }; 

coerce  Suffix, 
    from Str, 
    via { '-sf '.$_ }; 

# kokkos
subtype Kokkos, 
    as Str,
    where { $_ =~/^\-k/ }; 

coerce  Kokkos, 
    from Str,     , 
    via { '-k '.$_ }; 

# var
subtype Var, 
    as Str,      
    where { $_ =~/^\-v/ }; 

coerce  Var,  
    from ArrayRef, 
    via { 
        my @vars = ();  
        
        while ( my ($key, $value) = splice $_->@*, 0, 2 ) { 
            push @vars, '-v', $key, $value; 
        } 

        join ' ', @vars
    }; 

# package
subtype Pkg, 
    as Str, 
    where { $_ =~/^\-pk/ }; 

coerce Pkg, 
    from Str,
    via { '-pk '.$_ }; 
    
# accelerator package 
subtype Acc, 
    as Object;

coerce  Acc, 
    from Str, 
        via { ('HPC::App::LAMMPS::'.uc($_))->new }, 
    from ArrayRef, 
        via { 
            my ($pkg, @opts) = $_->@*;  
            ('HPC::App::LAMMPS::'.uc($pkg))->new(@opts) 
        };  

1
