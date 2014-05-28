clear; close all; clc;

%% Parameters
% Specify the number of time cycles to iterate through
c_T = 100;

% Specify the parameters for the area
c_size = 200; 
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


% Specify the parameters for solving the diffusion equation
ck_dg = 4000;
ck_gamma = 1;
ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
ck_movement_rule = 1; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
c_pmove_grad = 10;
ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_prolif_choosecell_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
v_parameters = [ck_dg;ck_gamma; ckp_moveprob; ck_neighbours;ck_movement_rule;c_depth_full;c_width_full;ck_moveprob_rule;ck_moveprob_cons;ck_move_norm_cons;ck_move_norm_slope;ck_moving_rule;c_pmove_grad;ck_prolifprob_rule;ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(c_width_full, c_depth_full);
m_cell = f_create_random_epithelium_new_m(m_cell, c_depth_full/2,c_width_full/2, 500,v_parameters);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart,c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = zeros(c_depth_full,c_width_full);

c_delta_timestep = 10;
m_GDNF1 = f_field_update_m(m_cell,v_parameters);

for i = 1:100
    i
    max(max(m_GDNF))
    min(min(m_GDNF))
    m_GDNF = f_field_update_time_implicit_m(m_cell,m_GDNF,v_parameters,c_delta_timestep);
    subplot(1,2,1),imagesc(m_GDNF)
    subplot(1,2,2),imagesc(m_GDNF1)
    pause(0.01)
end



imagesc(m_GDNF)
