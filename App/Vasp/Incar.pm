package HPC::App::Vasp::Incar; 

use Moose::Role; 
use MooseX::Types::Moose qw(Int Str HashRef); 

use List::Util 'max'; 
use String::Util 'trim'; 
use File::Slurp qw(read_file append_file edit_file_lines); 

use namespace::autoclean; 
use experimental 'signatures'; 

has gpu => ( 
    is      => 'rw',
    isa     => Int,
    traits  => ['Chained'],
    lazy    => 1, 
    default => 0, 
    trigger => sub ($self, $gpu, $=) { 
        $self->ncore(1)
             ->lreal('AUTO') 
             ->lscaaware('.false.')
    } 
); 

has incar => (
    is       => 'rw',
    isa      => Str,
    traits   => ['Chained'],
    lazy     => 1,
    default  => 'INCAR',
);

has '_cached_incar' => ( 
    is       => 'rw',
    isa      => HashRef,
    traits   => [qw(Chained Hash)],
    lazy     => 1,
    default  => sub ($self) { 
        my %incar = read_file($self->incar) =~ /^(\w+)\s+=\s+(.*)$/mg; 

        return { %incar }
    }, 
    handles  => { 
        '_has_incar' => 'defined',  
        '_set_incar' => 'set' 
    },  
); 

for my $param (qw(kpar ncore npar nsim lreal lscaaware lcharge lwave lscaaware)) { 
    has $param => (
        is        => 'rw',
        isa       => Int|Str,
        traits    => ['Chained'],
        trigger   => sub ($self, $var, @) { 
            $self->_has_incar(uc($param))
                ? edit_file_lines { s/($param.+?=).*$/$1 \U$var/i } $self->incar
                : append_file( 
                    $self->incar, 
                    "\n".join(' = ', uc($param), uc($var))); 
        
            $self->_set_incar(uc($param) => uc($var))
        }
    ) 
}

1
