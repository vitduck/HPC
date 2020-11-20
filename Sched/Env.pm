package HPC::Sched::Env;

use Moose::Role;
use MooseX::Types::Moose qw(HashRef ArrayRef); 

use HPC::Types::Sched::Env qw(Path Library_Path); 

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
        unset_env => 'delete' 
    }
); 

has 'path' => ( 
    is        => 'rw', 
    isa       => Path, 
    init_arg  => undef,
    predicate => '_has_path', 
    clearer   => '_unset_path', 
    traits    => ['Chained'],
    coerce    => 1, 
    lazy      => 1, 
    default   => sub {[]}
); 
 
has 'ld_library_path' => ( 
    is        => 'rw', 
    isa       => Library_Path, 
    init_arg => undef,
    predicate => '_has_ld_library_path', 
    clearer   => '_unset_ld_library_path', 
    traits   => ['Chained'],
    coerce   => 1, 
    lazy     => 1, 
    default  => sub {[]}
); 
   
# chained delegation methods
around [qw(set_env unset_env)] => sub ($method, $self, @args) { 
    $self->$method(@args); 

    return $self 
}; 

sub write_env ( $self ) { 
    $self->printf("export %s\n", $self->path)            if $self->_has_path; 
    $self->printf("export %s\n", $self->ld_library_path) if $self->_has_ld_library_path; 
    $self->print("\n")                                   if $self->_has_path or $self->_has_ld_library_path; 

    if ($self->has_env) { 
        for my $name ( sort $self->list_env ) { 
            # i.e. mvapich2 environment
            if ( ref $self->get_env($name) eq 'HASH' ) { 
                my $sub_env = $self->get_env($name); 

                for my $sub_name ( sort keys $sub_env->%* ) {  
                    $self->printf( "export %s\n", $sub_name.'='.$sub_env->{$sub_name} )
                } 
                
                $self->print("\n"); 
            # standard 
            } else { 
                $self->printf( "export %s\n", $name.'='.$self->get_env($name) )
            }
        } 

        $self->print("\n"); 
    } 

    return $self
} 

1 
