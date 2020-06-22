package HPC::App::Lammps::Opt; 

use Moose; 
use MooseX::XSAccessor; 

use namespace::autoclean; 

sub pkg_opt { 
    return [] 
}

__PACKAGE__->meta->make_immutable;

1
