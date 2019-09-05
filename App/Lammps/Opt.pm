package HPC::App::LAMMPS::OPT; 

use Moose; 

with 'HPC::App::LAMMPS::Package'; 

has '+suffix' => (
    default => 'opt',
);

sub options { 
    return ''
} 

__PACKAGE__->meta->make_immutable;

1
