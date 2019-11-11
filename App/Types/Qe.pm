package HPC::App::Types::Qe; 

use MooseX::Types::Moose qw/Str Int/; 
use MooseX::Types -declare => [qw(Input Output Image Pools Band Task Diag)]; 

subtype Input , as Str, where { /^\-/  }; 
subtype Output, as Str, where { /^>/   }; 
subtype Image , as Str, where { /^\-/  }; 
subtype Pools , as Str, where { /^\-/  }; 
subtype Band  , as Str, where { /^\-/  }; 
subtype Task  , as Str, where { /^\-/  }; 
subtype Diag  , as Str, where { /^\-/  }; 

coerce Input , from Str, via { '-in '.$_ }; 
coerce Output, from Str, via { '> '  .$_ }; 
coerce Image , from Int, via { '-ni '.$_ }; 
coerce Pools , from Int, via { '-nk '.$_ }; 
coerce Band  , from Int, via { '-nb '.$_ }; 
coerce Task  , from Int, via { '-nt '.$_ }; 
coerce Diag  , from Int, via { '-nd '.$_ }; 

1
