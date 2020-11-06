package HPC::Sched::Env;

use Moose::Role;
use MooseX::Types::Moose qw(HashRef ArrayRef); 

use namespace::autoclean; 
use experimental 'signatures';

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
        unset_env => 'delete' }
); 

# chained delegation methods
around [qw(set_env unset_env)] => sub ($method, $self, @args) { 
    $self->$method(@args); 

    return $self 
}; 

sub write_env ( $self ) { 
    if ($self->has_env) { 
        for my $env ( sort $self->list_env ) { 
            # append mode 
            if ( $env =~ /:a$/ ) { 
                my $env0 = (split /:/, $env)[0]; 
                
                $self->printf("export %s\n", $env0.'='.$self->get_env($env).':'."\$$env0")
            } else { 
                $self->printf("export %s\n", $env.'='.$self->get_env($env))
            }
        } 

        $self->print("\n"); 
    } 

    return $self
} 

1 
