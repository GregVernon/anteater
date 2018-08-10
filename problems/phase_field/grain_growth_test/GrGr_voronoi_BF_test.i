inactive = 'BCs'
[Mesh]
  type = FileMesh
  file = ../../geom/hollow_cyl_hole_r2.e
  dim = 3
[]

[GlobalParams]
  op_num = '4'
  var_name_base = 'gr'
[]

[Variables]
  [PolycrystalVariables]
  []
[]

[UserObjects]
  [voronoi]
    type = PolycrystalVoronoi
    method = UserSpecified
    points_file_name = ../../../../../Documents/maximal_sample_2.txt
    rand_seed = 105
    grain_num = 4
    coloring_algorithm = jp
  []
[]

[ICs]
  [PolycrystalICs]
    [PolycrystalColoringIC]
      polycrystal_ic_uo = voronoi
    []
  []
[]

[AuxVariables]
  [bnds]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [PolycrystalKernel]
  []
[]

[AuxKernels]
  [BndsCalc]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'timestep_end'
  []
[]

[BCs]
  inactive = 'Periodic'
  [Periodic]
    inactive = 'All'
    [All]
      auto_direction = 'x y'
    []
  []
[]

[Materials]
  [Copper]
    type = GBEvolution
    T = '500' # K
    wGB = 60 # nm
    GBmob0 = 2.5e-6 # m^4/(Js) from Schoenfelder 1997
    Q = 0.23 # Migration energy in eV
    GBenergy = 0.708 # GB energy in J/m^2
  []
[]

[Postprocessors]
  inactive = 'ngrains'
  [ngrains]
    type = FeatureFloodCount
    variable = 'bnds'
    threshold = 0.7
  []
[]

[Preconditioning]
  inactive = 'SMP'
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 31'
  l_tol = 1.0e-4
  l_max_its = 30
  nl_max_its = 20
  nl_rel_tol = 1.0e-9
  start_time = 0.0
  num_steps = 2
  dt = 80.0
[]

[Outputs]
  file_base = voronoi
  exodus = true
[]
