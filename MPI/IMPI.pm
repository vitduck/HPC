package HPC::MPI::IMPI;  

use Moose; 
use MooseX::Types::Moose  qw(Int Bool); 
use HPC::MPI::Types::IMPI qw(ENV_IMPI); 
use Text::Tabs; 
use namespace::autoclean; 

with qw(HPC::MPI::Base); 

has '+eagersize' => ( 
    trigger => sub { 
        my $self = shift; 

        $self->set_env(I_MPI_EAGER_THRESHOLD => $self->eagersize);
    }
); 

has '+env' => ( 
    isa    => ENV_IMPI, 
    coerce => 1
); 

has 'debug' => ( 
    is       => 'rw', 
    isa      => Int, 
    init_arg => undef,
    lazy     => 1, 
    writer   => 'set_debug',
    default  => 3, 
    trigger  => sub { 
        my $self = shift; 

        $self->set_env(I_MPI_DEBUG => $self->debug)
    }
); 

has 'ipm' => ( 
    is       => 'rw', 
    isa      => Bool, 
    lazy     => 1, 
    traits   => ['Bool'],
    init_arg => undef,
    default  => 0, 
    handles  => { 
         'enable_ipm' => 'set', 
        'disable_ipm' => 'unset', 
    }
); 

sub mpirun { 
    my $self = shift; 
    my @opts = (); 
    $tabstop = 4; 

    push @opts, $self->env($self->_env)->@* if $self->has_env; 

    return ['mpirun', expand(map "\t".$_, @opts)]
} 

__PACKAGE__->meta->make_immutable;

1
