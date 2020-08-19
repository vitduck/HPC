package HPC::Sched::Env;

use Moose::Role;
use MooseX::Types::Moose 'HashRef';

use feature 'signatures';
no warnings 'experimental::signatures';

has 'env' => (
    is       => 'rw', 
    isa      => HashRef,
    init_arg => undef,
    traits   => [qw(Hash Chained)],
    lazy     => 1, 
    default  => sub { {} }, 
    handles  => { 
        has_env   => 'count', 
        list_env  => 'keys',
        get_env   => 'get',
        set_env   => 'set', 
        unset_env => 'delete'
    } 
); 

# chained delegation methods
around [qw(set_env unset_env)] => sub ($method, $self, @args) { 
    $self->$method(@args); 

    return $self 
}; 

sub write_env ($self) { 
    if ($self->has_env) { 
        $self->print("\n"); 

        for my $env ( sort $self->list_env ) { 
            $self->printf("export %s\n", join('=', $env, $self->get_env($env)))
        } 
    } 

    return $self
} 

1 
