inactive = 'Variables Kernels'
[Mesh]
  type = FileMesh
  displacements = 'disp_x disp_y disp_z'
  file = ../geom/rubik_polyxtal.e
[]

[Variables]
  inactive = 'disp_x disp_y disp_z'
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[GlobalParams]
  volumetric_locking_correction = 'true'
  displacements = 'disp_x disp_y disp_z'
[]

[AuxVariables]
  [rotout]
    order = CONSTANT
    family = MONOMIAL
  []
  [gss]
    order = CONSTANT
    family = MONOMIAL
  []
  [e_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [fp_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [pk2_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [euler_1]
    family = MONOMIAL
    order = CONSTANT
  []
  [euler_2]
    family = MONOMIAL
    order = CONSTANT
  []
  [euler_3]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Functions]
  [tdisp]
    type = ParsedFunction
    value = '0.01*t'
  []
[]

[UserObjects]
  inactive = 'grain_maker'
  [slip_rate_gss]
    type = CrystalPlasticitySlipRateGSS
    variable_size = 12
    slip_sys_file_name = input_slip_sys.txt
    num_slip_sys_flowrate_props = 2
    flowprops = '1 4 0.001 0.1 5 8 0.001 0.1 9 12 0.001 0.1'
    uo_state_var_name = state_var_gss
  []
  [slip_resistance_gss]
    type = CrystalPlasticitySlipResistanceGSS
    variable_size = 12
    uo_state_var_name = state_var_gss
  []
  [state_var_gss]
    type = CrystalPlasticityStateVariable
    variable_size = 12
    groups = '0 4 8 12'
    group_values = '60.8 60.8 60.8'
    uo_state_var_evol_rate_comp_name = 'state_var_evol_rate_comp_gss'
    scale_factor = '1.0'
  []
  [state_var_evol_rate_comp_gss]
    type = CrystalPlasticityStateVarRateComponentGSS
    variable_size = 12
    hprops = '1.0 541.5 109.8 2.5'
    uo_slip_rate_name = slip_rate_gss
    uo_state_var_name = state_var_gss
  []
  [grain_maker]
    # Enter file data as prop#1, prop#2, .., prop#nprop
    type = PolycrystalVoronoi
    grain_num = 20
    coloring_algorithm = bt
  []
  [prop_read]
    type = ElementPropertyReadFile
    nprop = 3
    prop_file_name = euler_ang_file_rubik.txt
    read_type = grain
    ngrain = 8
  []
[]

[AuxKernels]
  [rotout]
    type = CrystalPlasticityRotationOutAux
    variable = rotout
    execute_on = 'timestep_end'
  []
  [gss]
    type = MaterialStdVectorAux
    variable = gss
    property = state_var_gss
    index = 0
    execute_on = 'timestep_end'
  []
  [e_zz]
    type = RankTwoAux
    variable = e_zz
    rank_two_tensor = lage
    index_j = 2
    index_i = 2
    execute_on = 'timestep_end'
  []
  [fp_zz]
    type = RankTwoAux
    variable = fp_zz
    rank_two_tensor = fp
    index_j = 2
    index_i = 2
    execute_on = 'timestep_end'
  []
  [pk2_zz]
    type = RankTwoAux
    variable = pk2_zz
    rank_two_tensor = pk2
    index_j = 2
    index_i = 2
    execute_on = 'timestep_end'
  []
  [euler_1]
    type = MaterialRealVectorValueAux
    variable = euler_1
    execute_on = 'TIMESTEP_END'
    property = Euler_angles
  []
  [euler_2]
    type = MaterialRealVectorValueAux
    component = 1
    variable = euler_2
    execute_on = 'TIMESTEP_END'
    property = Euler_angles
  []
  [euler_3]
    type = MaterialRealVectorValueAux
    component = 2
    variable = euler_3
    execute_on = 'TIMESTEP_END'
    property = Euler_angles
  []
[]

[BCs]
  [right_hold_x]
    type = PresetBC
    variable = disp_x
    boundary = 'right'
    value = 0
  []
  [right_hold_y]
    type = PresetBC
    variable = disp_y
    boundary = 'right'
    value = 0
  []
  [right_hold_z]
    type = PresetBC
    variable = disp_z
    boundary = 'right'
    value = 0
  []
  [left_hold_x]
    type = PresetBC
    variable = disp_x
    boundary = 'left'
    value = 0
  []
  [left_hold_y]
    type = PresetBC
    variable = disp_y
    boundary = 'left'
    value = 0
  []
  [left_pull_z]
    type = FunctionPresetBC
    variable = disp_z
    boundary = 'left'
    function = tdisp
  []
[]

[Materials]
  inactive = 'strain'
  [crysp]
    type = FiniteStrainUObasedCP
    stol = 1e-2
    tan_mod_type = exact
    uo_slip_rates = 'slip_rate_gss'
    uo_slip_resistances = 'slip_resistance_gss'
    uo_state_vars = 'state_var_gss'
    uo_state_var_evol_rate_comps = 'state_var_evol_rate_comp_gss'
  []
  [strain]
    type = ComputeFiniteStrain
    displacements = 'disp_x disp_y'
  []
  [elasticity_tensor]
    type = ComputeElasticityTensorCP
    C_ijkl = '1.684e5 1.214e5 1.214e5 1.684e5 1.214e5 1.684e5 0.754e5 0.754e5 0.754e5'
    fill_method = symmetric9
    read_prop_user_object = prop_read
  []
[]

[Postprocessors]
  inactive = 'stress_zz'
  [gss]
    type = ElementAverageValue
    variable = 'gss'
    block = 'ANY_BLOCK_ID 0'
  []
  [stress_zz]
    type = ElementAverageValue
    variable = 'stress_zz'
    block = 'ANY_BLOCK_ID 0'
  []
  [e_zz]
    type = ElementAverageValue
    variable = 'e_zz'
    block = 'ANY_BLOCK_ID 0'
  []
  [fp_zz]
    type = ElementAverageValue
    variable = 'fp_zz'
    block = 'ANY_BLOCK_ID 0'
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  # Preconditioned JFNK (default)
  type = Transient
  dt = 0.01
  solve_type = PJFNK
  petsc_options_iname = '-pc_hypre_type'
  petsc_options_value = 'boomerang'
  nl_abs_tol = 1e-10
  nl_rel_step_tol = 1e-10
  dtmax = 10.0
  nl_rel_tol = 1e-10
  end_time = 1
  dtmin = 0.01
  num_steps = 10
  nl_abs_step_tol = 1e-10
[]

[Outputs]
  file_base = crysp_user_object_out
  exodus = true
[]

[Kernels]
  inactive = 'TensorMechanics'
  [TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    use_displaced_mesh = true
  []
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        strain = FINITE
        add_variables = true
        displacements = 'disp_x disp_y disp_z'
      []
    []
  []
[]
