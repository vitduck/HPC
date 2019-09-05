package HPC::PBS::Path; 

use Env qw(@LD_LIBRARY_PATH); 
use Moose::Role; 
use MooseX::Types::Moose qw/ArrayRef/; 

has '_ld_library_path' => ( 
    is       => 'rw',
    isa      => ArrayRef, 
    traits   => ['Array'], 
    init_arg => undef, 
    lazy     => 1, 
    clearer  => '_clear_ld_library_path', 
    default  => sub { \@LD_LIBRARY_PATH },
    handles  => { 
          list_ld_library_path => 'elements', 
        delete_ld_library_path => 'delete', 
         index_ld_library_path => 'first_index', 
    },  
); 

1 
