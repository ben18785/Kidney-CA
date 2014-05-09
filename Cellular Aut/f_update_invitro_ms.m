function [m_cell,m_GDNF] = f_update_invitro_ms(m_cell,m_GDNF,c_size,ck_dg,ck_gamma,ck_neighbours,ck_movement_rule,ck_moveprob_rule,ck_moving_rule)
% A function which updates the GDNF and cell matrices by updating each of
% the cells individually


% Specify the parameters for the area
% c_size = 200; 
c_width_full = c_size;
c_depth_full = c_size;
c_width_e = c_width_full;
c_width_m = c_width_full;
c_depth_e = 1;
c_separation = 0;
c_depth_m = c_size;
c_epithelium_density = 1; 
c_mesenchyme_density = 0.1;
c_depth_mesenstart = 1;
c_width_mesenstart = 1;


ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
% ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
c_pmove_grad = 10;
ck_prolifprob_rule = ck_moveprob_rule; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_prolif_choosecell_rule = ck_moving_rule; % Select the type of move for probabilistically choosing between the available moves 
v_parameters = [ck_dg;ck_gamma; ckp_moveprob; ck_neighbours;ck_movement_rule;c_depth_full;c_width_full;ck_moveprob_rule;ck_moveprob_cons;ck_move_norm_cons;ck_move_norm_slope;ck_moving_rule;c_pmove_grad;ck_prolifprob_rule;ck_prolif_choosecell_rule];


% Now go through and update the cell populations and GDNF
m_cell = f_update_cells_m(m_cell,m_GDNF,v_parameters);
m_GDNF = f_field_update_m(m_cell,v_parameters);