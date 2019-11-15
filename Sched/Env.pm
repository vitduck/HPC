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
        get      => 'get',
        set      => 'set', 
        unset    => 'delete',
        _has_env => 'count'
    } 
); 

# chained delegation methods
around [qw(set unset)] => sub ($method, $self, @args) { 
    $self->$method(@args); 

    return $self 
}; 

sub write_env ($self) { 
    if ($self->_has_env) { 
        $self->print("\n"); 

        for my $env (sort keys $self->env->%*) { 
            $self->printf("export %s\n", join('=', $env, $self->get($env)))
        } 
    } 

    return $self
} 

1 
