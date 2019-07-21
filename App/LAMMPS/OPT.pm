package HPC::App::LAMMPS::OPT; 

use Moose; 

with 'HPC::App::LAMMPS::Package';

has '+suffix' => (
    default => 'opt',
);

sub _build_package { 
    return ''
} 

__PACKAGE__->meta->make_immutable;

1
