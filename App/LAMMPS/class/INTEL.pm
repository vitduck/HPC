package HPC::App::LAMMPS::INTEL; 

use Moose;  

with 'HPC::App::LAMMPS::Package'; 

has 'opt' => ( 
    is       => 'rw', 
    isa      => 'HashRef[Str]', 
    traits   => ['Hash'],
    init_arg => undef, 
    lazy     => 1, 
    default  => sub {{ intel => 0, omp => 0 }}, 
    handles  => { 
        iterate  => 'kv', 
        set_nphi => [ set => 'intel' ], 
        get_nphi => [ get => 'intel' ], 
        set_omp  => [ set => 'omp'   ], 
        get_omp  => [ get => 'omp'   ], 
        set_mode => [ set => 'mode'  ], 
        get_mode => [ get => 'mode'  ], 
        set_lrt  => [ set => 'lrt'   ], 
        get_lrt  => [ get => 'lrt'   ]
    }, 
    clearer  => 'reset_opt'
); 

after qr/^(set|reset)_/ => sub {
    my $self = shift; 

    $self->_clear_pk
}; 

sub _build_pk { 
    my $self = shift; 
    my @opts = (); 

    push @opts, 'intel', $self->get_nphi; 

    for my $pair ($self->iterate) { 
        next if $pair->[0] eq 'intel'; 
        push @opts, $pair->@*; 
    }

    return join(' ', '-pk', @opts) 
} 

__PACKAGE__->meta->make_immutable;

1
