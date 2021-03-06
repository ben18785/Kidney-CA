clear; close all; clc;

%% Parameters
% Specify the number of time cycles to iterate through
c_T = 5;

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
ck_dg = 100;
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
m_cell = f_create_random_epithelium_m(m_cell, c_depth_full/2,c_width_full/2, 500,v_parameters);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart,c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);

% Plot the initial GDNF field and the cell matrix
% subplot(1,2,1),imagesc(m_cell)
% title('Cell distribution')
% subplot(1,2,2),imagesc(m_GDNF)
% title('GDNF distribution')

%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
[m_cell,m_GDNF] = f_life_cycle_iterator_ms(m_cell,m_GDNF,c_T,v_parameters);

% First of all make all the components of the image which are not 1 zero
m_cell = m_cell.*(m_cell==1);
imagesc(m_cell)

% Find the connected components of the image
cell_mcell_connected = bwconncomp(m_cell, 8);

% Get the number of objects in the cell array
cn_objects = cell_mcell_connected.NumObjects;

% Get the area property and perimeter properties and store these
cell_area = regionprops(cell_mcell_connected,'Area');
cell_perimeter = regionprops(cell_mcell_connected,'Perimeter');

% Take the one with the largest area
c_area = 0;
c_largest_index = 0;

for i = 1:cn_objects
    if cell_area(i).Area > c_area
        c_largest_index = i;
        c_area = cell_area(i).Area;
    end
end

grain = false(size(m_cell));
grain(cell_mcell_connected.PixelIdxList{c_largest_index}) = true;
subplot(1,2,1),imagesc(m_cell)
subplot(1,2,2),imagesc(grain)

cn_area_true = sum(sum(m_cell==1));
c_area_approx = cell_area(c_largest_index).Area;
c_area_ratio = c_area_approx/cn_area_true;
c_perimeter_approx = cell_perimeter(c_largest_index).Perimeter;



