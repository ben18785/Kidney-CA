function v_parameters = f_update_vparameters_void(hObject,handles)
% A function which updates v_paramaters based on the parameters in handles

% Update handles structure
guidata(hObject, handles);

v_parameters(1) = handles.ck_dg; % Diffusion
v_parameters(2) = handles.ck_gamma; % GDNF production vs consumption
v_parameters(3) = handles.ckp_moveprob; % Probability of move vs proliferate
v_parameters(4) = handles.ck_neighbours; % Number of nearest neighbours to consider for epithelium moving/proliferating
v_parameters(5) = handles.ck_movement_rule; % The rule dictating allowed moves of epithelium
v_parameters(6) = handles.c_depth_full; % Depth
v_parameters(7) = handles.c_width_full; % Width
v_parameters(8) = handles.ck_moveprob_rule; % Select the type of rule to use for P(move)
v_parameters(9) = handles.ck_moveprob_cons; % C0
v_parameters(10) = handles.ck_move_norm_cons; % Constant C1
v_parameters(11) = handles.ck_move_norm_slope; % Constant C2
v_parameters(12) = handles.ck_moving_rule; % Rule used to select probabilistically between epithelium moves
v_parameters(13) = handles.c_pmove_grad; % Gradient used in, for example, multinomial logit used in the above rule
v_parameters(14) = handles.ck_prolifprob_rule; % Select the type of rule to use for P(prolif) 
v_parameters(15) = handles.ck_prolif_choosecell_rule; % Rule used to select probabilistically between epithelium proliferations
v_parameters(16) = handles.c_beta_mesmove; % A coefficient measuring the strength of discrimination against those moves for mesenchyme which are not in the direction they were pushed
v_parameters(17) = handles.c_mes_movement; % Choose the rule for specifying the mesenchyme target cells
v_parameters(18) = handles.c_mes_trapped; % The maximum number of 8-nearest neighbour epithelium cells which can be neighbouring on a given mesenchyme cell after moving it
v_parameters(19) = handles.c_mes_allowed; % Choose the rule specifying whether a mesenchyme can occupy a spot; based on c_mes_trapped as above
v_parameters(20) = handles.c_principal; % The number of moves forward allowed for mesenchyme if implementing non-local move
v_parameters(21) = handles.c_secondary; % The number of moves sideways allowed for mesenchyme if implementing non-local move

% Those parameters due to an active mesenchyme moving
v_parameters(22) = handles.ck_mes_move; % The probability of a mesenchyme choosing to go down branch corresponding to 'moving'.
v_parameters(23) = handles.ck_mes_prolif; % The probability of a mesenchyme choosing to go down branch corresponding to 'proliferating' 
v_parameters(24) = handles.ck_mes_diff; % The probability of a mesenchyme choosing to go down branch corresponding to 'differentiating'
v_parameters(25) = handles.ck_mes_death; % The probability of a mesenchyme choosing to go down branch corresponding to 'death'
v_parameters(26) = handles.ck_mes_target_allowed; % The rule to be used to determine those allowed cells which the mesenchyme can move into. 1 is local 8-NN if there are free cells.
v_parameters(27) = handles.ck_mes_moveprob_rule; % The rule used for P(mes move) in f_mes_move_prob_c
v_parameters(28) = handles.ck_mes_moveprob_rule1_cons; % The constant used for P(mes move) if rule 1 is selected in f_mes_move_prob_c
v_parameters(29) = handles.ck_mes_move_target_rule; % The rule used to select between targets for the moving mesenchyme in f_mes_move_cell
v_parameters(30) = handles.ck_mes_prolif_target_rule; % The rule used to select between target cells for the proliferating mesenchyme in f_mes_move_cell
v_parameters(31) = handles.ck_mes_prolifprob_rule;% The rule used for P(mes prolif) in f_mes_move_prob_c
v_parameters(32) = handles.ck_mes_prolifprob_rule1_cons; % The constant used for P(mes prolif) if rule 1 is selected in f_mes_move_prob_c
v_parameters(33) = handles.c_turn_on_active_mesenchyme; % A switch to turn on or off the active mesenchyme
v_parameters(34) = handles.ck_mes_moveprob_rule2_discons_move_c1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving
v_parameters(35) = handles.ck_mes_moveprob_rule2_discons_move_c2; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving
v_parameters(36) = handles.ck_mes_moveprob_rule2_discons_prolif_c1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating
v_parameters(37) = handles.ck_mes_moveprob_rule2_discons_prolif_c2; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating
v_parameters(38) = handles.ck_mes_move_target_disdiscrim; % A negative parameter which governs the strength at which target cells (in moving a mesenchyme actively) which are further away from the mesenchyme are discriminated
v_parameters(39) = handles.ck_mes_prolif_target_disdiscrim; % A negative parameter which governs the strength at which target cells (in proliferating a mesenchyme actively) which are further away from the mesenchyme are discriminated