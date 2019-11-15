package HPC::Sched::Job; 

use Moose::Role; 
use MooseX::Types::Moose 'Str'; 
use namespace::autoclean;
use feature 'signatures';
no warnings 'experimental::signatures';

has 'script' => ( 
    is       => 'rw', 
    isa      => Str, 
    init_arg => undef, 
    traits   => [ 'Chained' ],
    lazy     => 1, 
    default  => 'run.sh', 
    trigger  => sub ($self, $file, @) { $self->io_write($file) } 
); 

sub write ($self, $file) { 
    $self->script($file) 
         ->write_resource
         ->write_module 
         ->write_env
         ->write_cmd; 

    return $self
} 

# __PACKAGE__->meta->make_immutable;

1
