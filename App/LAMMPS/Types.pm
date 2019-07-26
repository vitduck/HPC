package HPC::App::LAMMPS::Types; 

use MooseX::Types -declare => [qw/Inp Log Suffix Kokkos Var Pkg ACC OPT OMP INTEL KOKKOS/]; 
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

class_type OPT,    { class => 'HPC::App::LAMMPS::OPT'    }; 
class_type OMP,    { class => 'HPC::App::LAMMPS::OMP'    }; 
class_type INTEL,  { class => 'HPC::App::LAMMPS::INTEL'  }; 
class_type KOKKOS, { class => 'HPC::App::LAMMPS::KOKKOS' }; 

# accelerator package 
subtype ACC, 
    as OPT|OMP|INTEL|KOKKOS;  

coerce  ACC, 
    from Str, 
    via { ('HPC::App::LAMMPS::'.uc($_))->new };  
1
