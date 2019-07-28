package HPC::App::LAMMPS::OPT; 

use Moose; 

with 'HPC::App::LAMMPS::Package' => { -excludes => ['cmd'] }; 

has '+suffix' => (
    default => 'opt',
);

sub cmd { 
    my $self = shift; 

    return $self->suffix
} 

__PACKAGE__->meta->make_immutable;

1
