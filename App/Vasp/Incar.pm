package HPC::App::Vasp::Incar; 

use Moose::Role; 
use MooseX::Types::Moose  qw(Int HashRef); 
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
        set   => 'set', 
        unset => 'delete' }, 
    trigger  => sub ($self, $incar, @) { $self->_write_incar }
);

has 'kpar' => (
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_kpar',
    lazy      => 1,
    default   => 1, 
    trigger   => sub ($self, $kpar, @) { $self->set(KPAR => $kpar) }
);

has 'ncore' => ( 
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_ncore', 
    lazy      => 1,
    default   => 1, 
    trigger   => sub ($self, $ncore, @) { $self->set(NCORE => $ncore) }
);

has 'npar' => ( 
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate => '_has_npar',
    lazy      => 1,
    default   => 1, 
    trigger   => sub ($self, $npar, @) { $self->set(NPAR => $npar) }
); 

has 'nsim' => ( 
    is        => 'rw',
    isa       => Int,
    traits    => ['Chained'],
    predicate =>  '_has_nsim',
    lazy      => 1,
    default   => 4, 
    trigger   => sub ($self, $nsim, @) { $self->set(NSIM => $nsim) }
);

sub _parse_incar ($self) { 
    my $num   = 0; 
    my %cache = ();  

    while ( defined( local $_ =  $self->getline ) ) {
        if ( $_ eq ''    ) { next } # blanks 
        if ( /^\s*#/     ) { next } # comments 
        if ( /(.*)=(.*)/ ) { $cache{trim(uc($1))} = trim($2) }
    }

    $self->_close_io_read; 

    return { %cache }
}

sub _write_incar ($self) { 
    my %index  = map { $_ => 0 } sort keys $self->incar->%*; 
    my @params = grep{ $self->has($_) } qw(NSIM KPAR NPAR NCORE); 

    # sort with preferential order for @params
    @index{@params} = map 1, @params; 
    my @sorted      = sort {$index{$a} <=> $index{$b}} keys %index; 
    
    # printing format
    my $length = max(map length($_), @sorted); 

    for my $param ( @sorted ) { 
        $self->printf(
            "%-${length}s = %s\n", 
            $param, 
            $self->get($param)
        ); 
    }

    $self->_close_io_write; 
}

1
