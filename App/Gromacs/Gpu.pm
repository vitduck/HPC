package HPC::App::Gromacs::Gpu; 

use Moose::Role; 
use MooseX::Attribute::Chained; 

use MooseX::Types::Moose 'Int'; 

use HPC::Types::App::Gromacs qw(Npme Tunepme); 

has 'gpudirect' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'], 
    predicate => '_has_gpudirect',
    lazy      => 1, 
    default   => 0,
    trigger   => sub { 
        my $self = shift; 

        $self->nb('gpu')
             ->bonded('gpu')
             ->pme('gpu')
             ->npme(1)
             ->tunepme(0)
    }
);

1 
