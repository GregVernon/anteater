# This simulation uses the piece-wise linear strain hardening model
# with the incremental small strain formulation; incremental small strain
# is required to produce the strain_increment for the DiscreteRadialReturnStressIncrement
# class, which handles the calculation of the stress increment to return
# to the yield surface in a J2 (isotropic) plasticity problem.
#
# This test assumes a Poissons ratio of 0.3 and applies a displacement loading
# condition on the top in the y direction.
#
# An identical problem was run in Abaqus on a similar 1 element mesh and was used
# to verify the SolidMechanics solution; this TensorMechanics code matches the
# SolidMechanics solution.
#
# Mechanical strain is the sum of the elastic and plastic strains but is different
# from total strain in cases with eigen strains, e.g. thermal strain.
inactive = 'MeshModifiers'
[Mesh]
  type = FileMesh
  file = ../geom/hollow_cyl_hole_r0.e
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Functions]
  inactive = 'top_pull'
  [top_pull]
    type = ParsedFunction
    value = 't*(0.0625)'
  []
  [hf]
    type = PiecewiseLinear
    x = '0  0.001 0.003 0.023'
    y = '50 52    54    56'
  []
[]

[BCs]
  [left_pull]
    type = FunctionPresetBC
    variable = disp_z
    boundary = 'left'
    function = 1.0*t
  []
  [right_hold_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'right'
    value = 0.0
  []
  [right_hold_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'right'
    value = 0.0
  []
  [right_hold_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'right'
    value = 0.0
  []
  [left_hold_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0.0
  []
  [left_hold_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'left'
    value = 0.0
  []
[]

[Materials]
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 2.1e5
    poissons_ratio = 0.3
  []
  [isotropic_plasticity]
    type = IsotropicPlasticityStressUpdate
    yield_stress = 50.0
    hardening_function = hf
  []
  [radial_return_stress]
    type = ComputeMultipleInelasticStress
    tangent_operator = elastic
    inelastic_models = 'isotropic_plasticity'
  []
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '101'
  line_search = none
  l_max_its = 50
  nl_max_its = 50
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-10
  l_tol = 1e-3
  start_time = 0.0
  end_time = 0.01
  dt = 0.001
  dtmin = 0.0001
[]

[Outputs]
  [out]
    type = Exodus
    elemental_as_nodal = true
  []
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        strain = FINITE
        add_variables = true
        generate_output = 'stress_yy plastic_strain_xx plastic_strain_yy plastic_strain_zz'
      []
    []
  []
[]

[MeshModifiers]
[]

[Adaptivity]
  initial_steps = 1
  initial_marker = uniform_marker
  inactive = 'Indicators'
  [Indicators]
  []
  [Markers]
    [uniform_marker]
      type = UniformMarker
      mark = REFINE
    []
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    petsc_options_value = 'hypre boomeramg'
    petsc_options_iname = '-pc_type -pc_hypre_type'
  []
[]
