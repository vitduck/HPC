package HPC::MPI::Types; 

use IO::File; 
use MooseX::Types -declare => [qw(MPI IMPI OPENMPI MVAPICH2)]; 

use MooseX::Types::Moose qw/Undef Str Int Object/;  

class_type IMPI,     { class => 'HPC::MPI::IMPI::Module'     }; 
class_type OPENMPI,  { class => 'HPC::MPI::OPENMPI::Module'  }; 
class_type MVAPICH2, { class => 'HPC::MPI::MVAPICH2::Module' }; 

subtype MPI, 
    as IMPI|OPENMPI|MVAPICH2; 

coerce MPI, 
    from Str, 
    via { 
        my ($mpi, $version) = split /\//, $_;

        # cray-derived modules
        # $mpi =~ s/cray-//; 
        
        my $MPI = join '::', 'HPC','MPI',uc($mpi),'Module';  
        
        $MPI->new( 
            module  => $mpi, 
            version => $version
        )
    }; 

# coerce IMPI,
    # from Str, 
    # via { 
        # my ($module, $version) = split /\//, $_;

        # return HPC::MPI::IMPI::Module->new(
            # module  => $module, 
            # version => $version
        # )
    # }; 

# coerce OPENMPI,
    # from Str, 
    # via { 
        # my ($module, $version) = split /\//, $_;

        # return HPC::MPI::OPENMPI::Module->new(
            # module  => $module, 
            # version => $version
        # )
    # }; 

# coerce MVAPICH2, 
    # from Str, 
    # via { 
        # my ($module, $version) = split /\//, $_;

        # return HPC::MPI::MVAPICH2::Module->new(
            # module  => $module, 
            # version => $version
        # )
    # }; 

1
