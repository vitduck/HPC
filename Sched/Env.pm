package HPC::Sched::Env;

use Moose::Role;
use MooseX::Types::Moose qw(HashRef ArrayRef); 
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

has 'ld_library_path' => ( 
    is        => 'rw',
    isa       => ArrayRef, 
    traits    => [qw(Array Chained)], 
    init_arg  => undef, 
    predicate => '_has_ld_library_path', 
    clearer   => '_unset_ld_library_path', 
    lazy      => 1, 
    default   => sub {['$LD_LIRARY_PATH']}, 
    handles   => {
        append_ld_library_path => 'unshift', 
          list_ld_library_path => 'elements' }, 
    trigger   => sub ($self, $ld, @) {
        $self->set_env(LD_LIBRARY_PATH => join(':', $ld->@*))
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
