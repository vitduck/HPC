package HPC::PBS::Types; 

use Moose::Role; 
use Moose::Util::TypeConstraints; 
use HPC::MPI::Module; 

subtype 'HPC::PBS::Types::MPI' 
    => as 'Object'
    => where { $_->isa("HPC::MPI::Module") }; 

coerce 'HPC::PBS::Types::MPI' 
    => from 'Str', 
    => via { 
        my ($mpi, $version) = split /\//, $_; 

        # for cray-impi/*
        $mpi  =~ s/-//; 
        
        my $role = join '::', 'HPC', 'MPI', uc($mpi);  
        HPC::MPI::Module
            ->with_traits($role)
            ->new(module => $mpi, version => $version)
    }; 

1
