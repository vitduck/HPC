package HPC::App::Vasp::Incar; 

use Moose::Role; 
use MooseX::Types::Moose  qw(HashRef); 
use List::Util 'max'; 
use String::Util 'trim'; 
use feature 'signatures'; 
no warnings 'experimental::signatures'; 

has incar => (
    is       => 'rw',
    isa      => HashRef,
    init_arg => undef,
    traits   => [qw(Hash)],
    lazy     => 1,
    builder  => '_parse_incar', 
    handles  => { 
        has   => 'exists',
        get   => 'get', 
        unset => 'delete', 
        ncore => [ set => 'NCORE' ], 
        nsim  => [ set => 'NSIM'  ], 
        npar  => [ set => 'NPAR'  ], 
        kpar  => [ set => 'KPAR'  ]
    }, 
    trigger  => sub ($self, $incar, @) {
        $self->_write_incar; 
        $self->_close_io_write; 
    } 
);

# chained native delegations
around [qw(ncore nsim npar kpar)] => sub ($method, $self, $param) { 
    $self->$method($param); 

    return $self
}; 

sub _parse_incar ($self) { 
    my $num   = 0; 
    my %cache = ();  

    while ( defined( local $_ =  $self->getline ) ) {
        if ( $_ eq ''    ) { next } # blanks 
        if ( /^\s*#/     ) { next } # comments 
        if ( /(.*)=(.*)/ ) { $cache{trim(uc($1))} = trim($2) }
    }

    return { %cache }
} 

sub _write_incar ($self) { 
    my @params = sort keys $self->incar->%*; 
    my $length = max(map length($_), @params); 

    for my $param ( @params  ) { 
        $self->printf("%-${length}s = %s\n", $param, $self->get($param)); 
    } 
}

1
