package HPC::PBS::App;  

use Moose::Role; 

use HPC::App::Aps; 
use HPC::App::Numa; 
use HPC::App::Lammps; 
use HPC::App::Gromacs; 
use HPC::PBS::Types::App qw(Aps Numa Gromacs Lammps); 

has 'aps' => ( 
    is       => 'rw', 
    isa      => Aps,
    coerce   => 1, 
    init_arg => undef, 
    writer   => 'set_aps',
    handles  => { 
        set_aps_type   => 'set_type',
        set_aps_level  => 'set_level',
        set_aps_report => 'set_report', 
        aps_cmd        => 'cmd'
    } 
); 

has 'numa' => (
    is       => 'rw', 
    isa      => Numa,
    coerce   => 1, 
    init_arg => undef, 
    writer   => 'set_numa',
    handles  => { 
        set_numa_membind   => 'set_membind',
        set_numa_preferred => 'set_preferred', 
        numa_cmd           => 'cmd'
    }
); 

has 'lammps' => (
    is        => 'rw', 
    isa       => Lammps, 
    coerce    => 1, 
    init_arg  => undef,
    writer    => 'set_lammps',
    handles   => { 
        set_lammps_bin                  => 'set_bin',

        set_lammps_omp                  => 'set_lammps_omp',
        set_lammps_omp_nthreads         => 'set_omp_nthreads',  
        set_lammps_omp_neigh            => 'set_omp_neigh',  

        set_lammps_intel                => 'set_lammps_intel',
        set_lammps_intel_nphi           => 'set_intel_nphi',
        set_lammps_intel_mode           => 'set_intel_mode',
        set_lammps_intel_omp            => 'set_intel_omp',
        set_lammps_intel_lrt            => 'set_intel_lrt',
        set_lammps_intel_balance        => 'set_intel_balance',
        set_lammps_intel_ghost          => 'set_intel_ghost',
        set_lammps_intel_tpc            => 'set_intel_tpc',
        set_lammps_intel_tptask         => 'set_intel_tptask',

        set_lammps_gpu                  => 'set_lammps_gpu',
        set_lammps_gpu_ngpu             => 'set_gpu_ngpu',
        set_lammps_gpu_neigh            => 'set_gpu_neigh',
        set_lammps_gpu_newton           => 'set_gpu_newton',
        set_lammps_gpu_binsize          => 'set_gpu_binsize',
        set_lammps_gpu_split            => 'set_gpu_split',
        set_lammps_gpu_gpuID            => 'set_gpu_gpuID',
        set_lammps_gpu_tpa              => 'set_gpu_tpa',
        set_lammps_gpu_device           => 'set_gpu_device', 
        set_lammps_gpu_blocksize        => 'set_gpu_blocksize', 

        set_lammps_kokkos               => 'set_lammps_kokkos',
        set_lammps_kokkos_neigh         => 'set_kokkos_neigh',    
        set_lammps_kokkos_neigh_qeq     => 'set_kokkos_neigh_qeq',
        set_lammps_kokkos_neigh_thread  => 'set_kokkos_neigh_thread', 
        set_lammps_kokkos_newton        => 'set_kokkos_newton',       
        set_lammps_kokkos_binsize       => 'set_kokkos_binsize',      
        set_lammps_kokkos_comm          => 'set_kokkos_comm',         
        set_lammps_kokkos_comm_exchange => 'set_kokkos_comm_exchange',
        set_lammps_kokkos_comm_forward  => 'set_kokkos_comm_forward', 
        set_lammps_kokkos_comm_reverse  => 'set_kokkos_comm_reverse', 
        set_lammps_kokkos_gpu_direct    => 'set_kokkos_gpu_direct', 

        unset_lammps_opt                => 'unset_opt',
        unset_lammps_omp                => 'unset_omp',
        unset_lammps_gpu                => 'unset_gpu',
        unset_lammps_intel              => 'unset_intel',
        unset_lammps_kokkos             => 'unset_kokkos',

        lammps_cmd                      => 'cmd',
    }
); 

has 'gromacs' => (
    is        => 'rw', 
    isa       => Gromacs, 
    coerce    => 1, 
    init_arg  => undef,
    writer    => 'set_gromacs',
    handles   => { 
        set_gromacs_bin        => 'set_bin',
        set_gromacs_tpr        => 'set_trp',
        set_gromacs_verbose    => 'set_verbose', 
        set_gromacs_deffnm     => 'set_deffnm',
        set_gromacs_log        => 'set_log',
        set_gromacs_confout    => 'set_confout',
        set_gromacs_tunepme    => 'set_tunepme',
        set_gromacs_dlb        => 'set_dlb',
        set_gromacs_ddorder    => 'set_ddorder',
        set_gromacs_nsteps     => 'set_nsteps',
        set_gromacs_resetstep  => 'set_resetstep',
        set_gromacs_resethway  => 'set_resethway',
        set_gromacs_nt         => 'set_nt',
        set_gromacs_ntmpi      => 'set_ntmpi',
        set_gromacs_ntomp      => 'set_ntomp',

        gromacs_cmd            => 'cmd'
    }
); 

1
