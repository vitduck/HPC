package HPC::MPI::OPENMPI::MCA; 

use Moose::Role; 
use Moose::Util::TypeConstraints; 
use MooseX::Types::Moose qw(HashRef); 
use HPC::MPI::OPENMPI::Options qw(MCA_OPENMPI); 

has '_mca' => (
    is       => 'rw',
    isa      => HashRef,
    traits   => ['Hash'],
    init_arg => undef,
    default  => sub {{}},
    handles  => {
        has_mca   => 'count',
        get_mca   => 'get',
        set_mca   => 'set',
        unset_mca => 'delete',
        reset_mca => 'clear',
        list_mca  => 'keys',
    }
);

has 'mca' => (
    is       => 'rw',
    isa      => MCA_OPENMPI,
    coerce   => 1,
    init_arg => undef,
    default  => sub {{}}, 
);

1
