package HPC::App::LAMMPS::Types; 

use MooseX::Types -declare => [qw(
    Inp Log Suffix Kokkos Var Pkg 
    OPT OMP KOKKOS INTEL GPU )]; 

use MooseX::Types::Moose qw/Str Int ArrayRef Object/;

# input
subtype Inp,
    as Str, 
    where { /^\-i/ }; 

coerce  Inp, 
    from Str, 
    via { '-i '.$_ }; 

# log
subtype Log, 
    as Str, 
    where { /^\-l/ }; 

coerce  Log, 
    from Str, 
    via { '-l '.$_ }; 

# suffix 
subtype Suffix,  
    as Str, 
    where { /^\-sf/ }; 

coerce  Suffix, 
    from Str, 
    via { '-sf '.$_ }; 

# kokkos
subtype Kokkos, 
    as Str,
    where { /^\-k/ }; 

coerce  Kokkos, 
    from Int,      
    via { '-k on t '.$_ }; 

# var
subtype Var, 
    as Str,      
    where { /^\-v/ }; 

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
    as Str;  
    # where { $_ =~/^\-pk/ }; 

coerce Pkg, 
    from ArrayRef,
    via { join ' ', '-pk', $_->@* }; 

# accelerator package 
class_type OPT,    { class => 'HPC::App::LAMMPS::OPT'    }; 
class_type OMP,    { class => 'HPC::App::LAMMPS::OMP'    }; 
class_type GPU,    { class => 'HPC::App::LAMMPS::GPU'    }; 
class_type INTEL,  { class => 'HPC::App::LAMMPS::INTEL'  }; 
class_type KOKKOS, { class => 'HPC::App::LAMMPS::KOKKOS' }; 

1
