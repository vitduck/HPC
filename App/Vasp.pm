package HPC::App::Vasp;  

use Moose; 
use MooseX::Aliases;
use MooseX::XSAccessor; 
use MooseX::Attribute::Chained; 
use MooseX::StrictConstructor; 

use namespace::autoclean;
use experimental 'signatures'; 

with qw(
    HPC::Debug::Dump
    HPC::Plugin::Cmd
    HPC::App::Vasp::Incar
);

sub _opts {
    return qw()
}

__PACKAGE__->meta->make_immutable;

1
