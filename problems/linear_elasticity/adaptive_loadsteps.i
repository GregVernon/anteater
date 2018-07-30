inactive = 'Adaptivity'
[Mesh]
  type = FileMesh
  file = ../geom/hollow_cyl_hole_r0.e
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[AuxVariables]
  [stress_11]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [stress_11]
    type = RankTwoAux
    variable = stress_11
    rank_two_tensor = stress
    index_j = 1
    index_i = 1
  []
[]

[BCs]
  [left_pin_x]
    type = PresetBC
    variable = disp_x
    boundary = 'left'
    value = 0
  []
  [left_pin_y]
    type = PresetBC
    variable = disp_y
    boundary = 'left'
    value = 0
  []
  [left_pin_z]
    type = PresetBC
    variable = disp_z
    boundary = 'left'
    value = 0
  []
  [right_pin_x]
    type = PresetBC
    variable = disp_x
    boundary = 'right'
    value = 0
  []
  [right_pin_y]
    type = PresetBC
    variable = disp_y
    boundary = 'right'
    value = 0
  []
  [right_stretch_z]
    type = FunctionPresetBC
    variable = disp_z
    boundary = 'right'
    function = -0.3*t
  []
[]

[Materials]
  [stress]
    type = ComputeLinearElasticStress
  []
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    poissons_ratio = 0.1
    youngs_modulus = 1e6
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  nl_rel_tol = 1e-5
  nl_max_its = 10
  petsc_options_iname = '-pc_type -pc_hypre_type'
  num_steps = 100000
  l_max_its = 20
  petsc_options_value = 'hypre boomeramg'
  l_tol = 1e-8
  solve_type = NEWTON
  end_time = 10
  [TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 1
  []
[]

[Outputs]
  exodus = true
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        strain = SMALL
        add_variables = true
      []
    []
  []
[]

[Adaptivity]
[]
