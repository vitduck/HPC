package HPC::Types::Ime::Ctl; 

use MooseX::Types::Moose qw(Str Int ArrayRef);
use MooseX::Types -declare => [qw(Scratch_Ime Ime_Block Ime_Verbose Ime_File Ime_Dir)];
use IO::File;

subtype Scratch_Ime, as Str, where { /scratch_ime/ }; 
subtype Ime_Block,   as Str, where { /^\-b/        };
subtype Ime_Verbose, as Str, where { /^\-V/        }; 
subtype Ime_File,    as Str; 
subtype Ime_Dir,     as Str; 

coerce  Scratch_Ime, from Str,      via { s/scratch/scratch_ime/r }; 
coerce  Ime_Block,   from Int,      via { '-b' }; 
coerce  Ime_Verbose, from Int,      via { '-V' }; 
coerce  Ime_File,    from ArrayRef, via { join(' ', $_->@*) }; 
coerce  Ime_Dir,     from ArrayRef, via { join(' ', $_->@*) }; 

1
