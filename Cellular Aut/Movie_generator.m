clear; close all; clc;

%% Specify parameters

% Specify basic simulation parameters governing time and initial location
% of epithelium and mesenchyme
c_T = 100;

c_simulation = 1;
c_size = 200;
c_width_full = c_size*2;
c_depth_full = c_size;
c_width_e = c_width_full;
c_width_m = 80;
c_depth_e = 20;
c_separation = 60;
c_depth_m = 20;
c_epithelium_density = 1; 
c_mesenchyme_density = 0.5;
c_width_mesenstart = c_size - 40;
c_depth_mesenstart = c_depth_e+c_separation;

% Specify the parameters in the v_parameters vector
ck_dg = 100;
ck_gamma = 1;
ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
ck_movement_rule = 8; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
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
ck_move_norm_cons = -50; % The constant to be used in the argument of the norm cdf function used in rule 2/3
ck_move_norm_slope = 160; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
ck_moving_rule = 7; % Select the type of move for probabilistically choosing between the available moves 
c_pmove_grad = 10; %The coefficients used in targeting cells
% c_target_cons = 0; % Another constant used in targeting cells
ck_prolifprob_rule = ck_moveprob_rule; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_prolif_choosecell_rule = ck_moving_rule; % Select the type of move for probabilistically choosing between the available moves 
c_beta_mesmove = -3; % A coefficient measuring the strength of discrimination against those moves for mesenchyme which are not in the direction they were pushed.
c_mes_movement = 2; % Choose the rule for specifying the mesenchyme target cells. '1' means that the cells are chosen randomly. '2' means that the cells are chosen probabilistically weighted towards the direction they were pushed.
c_mes_trapped = 8; % The maximum number of 8-nearest neighbour epithelium cells which can be neighbouring on a given mesenchyme cell after moving it. Aims to stop MM becoming trapped!
c_mes_allowed = 1; % Choose the rule specifying whether a mesenchyme can occupy a spot. 1 means all vacant spots, 2 means only those spots which are connected less than c_mes_trapped
c_principal = 10; % The maximum number of moves forward (from direction pushed) considered for mesenchyme if implementing non-local mesenchyme movement rule
c_secondary = 2; % The maximum number of moves sideways (from direction pushed) considered for mesenchyme if implementing non-local mesenchyme movement rule

% Active mesenchyme parameters
ck_mes_move = 0.1; % The probability of a mesenchyme choosing to go down branch corresponding to 'moving'. Not the same as moving, as it is yet to be determined whether the cell actually moves. Same for below 3. Local conditions and rules will determine if the action is actually taken.
ck_mes_prolif = 0.9; % The probability of a mesenchyme choosing to go down branch corresponding to 'proliferating'
ck_mes_diff = 0; % The probability of a mesenchyme choosing to go down branch corresponding to 'differentiating'
ck_mes_death = 1 - ck_mes_move - ck_mes_prolif - ck_mes_diff; % The probability of a mesenchyme choosing to go down branch corresponding to 'die'
ck_mes_target_allowed = 1; % The rule to be used to determine those allowed cells which the mesenchyme can move into. 1 is local 8-NN if there are free cells.
ck_mes_moveprob_rule = 1; % The rule used for P(mes move) in f_mes_move_prob_c
ck_mes_moveprob_rule1_cons = 0; % The constant used for P(mes move) if rule 1 is selected in f_mes_move_prob_c
ck_mes_move_target_rule = 1; % The rule used to select between targets for the moving mesenchyme in f_mes_move_cell
ck_mes_prolif_target_rule = 1; % The rule used to select between target cells for the proliferating mesenchyme in f_mes_move_cell
ck_mes_prolifprob_rule = 1;% The rule used for P(mes prolif) in f_mes_move_prob_c
ck_mes_prolifprob_rule1_cons = 0; % The constant used for P(mes prolif) if rule 1 is selected in f_mes_move_prob_c
c_turn_on_active_mesenchyme = 1; % A switch to allow the user to turn on or off the updating of the mesenchyme
ck_mes_moveprob_rule2_discons_move_c1 = -10; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving
ck_mes_moveprob_rule2_discons_move_c2 = 0; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving. Should be negative
ck_mes_moveprob_rule2_discons_prolif_c1 = -1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating
ck_mes_moveprob_rule2_discons_prolif_c2 = -0.1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating. Should be negative

%% Allocate parameters into a vector
v_parameters(1) = ck_dg; % Diffusion
v_parameters(2) = ck_gamma; % GDNF production vs consumption
v_parameters(3) = ckp_moveprob; % Probability of move vs proliferate
v_parameters(4) = ck_neighbours; % Number of nearest neighbours to consider for epithelium moving/proliferating
v_parameters(5) = ck_movement_rule; % The rule dictating allowed moves of epithelium
v_parameters(6) = c_depth_full; % Depth
v_parameters(7) = c_width_full; % Width
v_parameters(8) = ck_moveprob_rule; % Select the type of rule to use for P(move)
v_parameters(9) = ck_moveprob_cons; % C0
v_parameters(10) = ck_move_norm_cons; % Constant C1
v_parameters(11) = ck_move_norm_slope; % Constant C2
v_parameters(12) = ck_moving_rule; % Rule used to select probabilistically between epithelium moves
v_parameters(13) = c_pmove_grad; % Gradient used in, for example, multinomial logit used in the above rule
v_parameters(14) = ck_prolifprob_rule; % Select the type of rule to use for P(prolif) 
v_parameters(15) = ck_prolif_choosecell_rule; % Rule used to select probabilistically between epithelium proliferations
v_parameters(16) = c_beta_mesmove; % A coefficient measuring the strength of discrimination against those moves for mesenchyme which are not in the direction they were pushed
v_parameters(17) = c_mes_movement; % Choose the rule for specifying the mesenchyme target cells
v_parameters(18) = c_mes_trapped; % The maximum number of 8-nearest neighbour epithelium cells which can be neighbouring on a given mesenchyme cell after moving it
v_parameters(19) = c_mes_allowed; % Choose the rule specifying whether a mesenchyme can occupy a spot; based on c_mes_trapped as above
v_parameters(20) = c_principal; % The number of moves forward allowed for mesenchyme if implementing non-local move
v_parameters(21) = c_secondary; % The number of moves sideways allowed for mesenchyme if implementing non-local move

% Those parameters due to an active mesenchyme moving
v_parameters(22) = ck_mes_move; % The probability of a mesenchyme choosing to go down branch corresponding to 'moving'.
v_parameters(23) = ck_mes_prolif; % The probability of a mesenchyme choosing to go down branch corresponding to 'proliferating' 
v_parameters(24) = ck_mes_diff; % The probability of a mesenchyme choosing to go down branch corresponding to 'differentiating'
v_parameters(25) = ck_mes_death; % The probability of a mesenchyme choosing to go down branch corresponding to 'death'
v_parameters(26) = ck_mes_target_allowed; % The rule to be used to determine those allowed cells which the mesenchyme can move into. 1 is local 8-NN if there are free cells.
v_parameters(27) = ck_mes_moveprob_rule; % The rule used for P(mes move) in f_mes_move_prob_c
v_parameters(28) = ck_mes_moveprob_rule1_cons; % The constant used for P(mes move) if rule 1 is selected in f_mes_move_prob_c
v_parameters(29) = ck_mes_move_target_rule; % The rule used to select between targets for the moving mesenchyme in f_mes_move_cell
v_parameters(30) = ck_mes_prolif_target_rule; % The rule used to select between target cells for the proliferating mesenchyme in f_mes_move_cell
v_parameters(31) = ck_mes_prolifprob_rule;% The rule used for P(mes prolif) in f_mes_move_prob_c
v_parameters(32) = ck_mes_prolifprob_rule1_cons; % The constant used for P(mes prolif) if rule 1 is selected in f_mes_move_prob_c
v_parameters(33) = c_turn_on_active_mesenchyme; % A switch to turn on or off the active mesenchyme
v_parameters(34) = ck_mes_moveprob_rule2_discons_move_c1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving
v_parameters(35) = ck_mes_moveprob_rule2_discons_move_c2; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving
v_parameters(36) = ck_mes_moveprob_rule2_discons_prolif_c1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating
v_parameters(37) = ck_mes_moveprob_rule2_discons_prolif_c2; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating




%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(c_width_full, c_depth_full);
m_cell = f_create_epithelium_m(m_cell, c_width_e, c_depth_e, c_epithelium_density);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart,c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);



%% Run the simulation through the T time steps
c_mesen_running = 0;
global gc_error_count;
gc_error_count = 0;
FigHandle = figure('Position', [100, 100, 1000, 500]);
vidObj = VideoWriter('in_vivo.avi');
vidObj.FrameRate = 2;
open(vidObj);
% Go through the time steps 
for t = 1:c_T
        if gc_error_count > 0
            gc_error_count
        end
        
        t
        [m_cell,c_move,c_heterogeneity,c_mesenchyme_options,c_vacant_select,c_mesenchyme_select,c_cell_options] = f_update_cells_m(m_cell,m_GDNF,v_parameters);
        v_heterogeneity(t) = c_heterogeneity;
        
        % Average number of vacant spots available for the mesenchyme cells
        % to move into
        v_mesenchyme_options(t) = c_mesenchyme_options/c_mesenchyme_select;
        
        % Calculate the ratio of total cells chosen which are mesenchyme vs
        % vacant
        v_vacant_ratio(t) = 100*c_vacant_select/(c_mesenchyme_select+c_vacant_select);
        v_mesenchyme_ratio(t) = 100*c_mesenchyme_select/(c_mesenchyme_select+c_vacant_select);
        
        m_GDNF = f_field_update_m(m_cell,v_parameters);
        
        % Get the total number of epithelium cells
        c_epithelium = sum(sum(m_cell==1));
        
        % Now put it as a % of size of total region
        c_total = c_depth_full*c_width_full;
        c_epithelium_per = c_epithelium;
        v_epithelium(t) = c_epithelium_per;
        
        % Count the number of mesenchyme
        v_mesenchyme(t) = c_mesen_running;
        
        % Work out the acceptance rate
        c_acceptance = 100*c_move/c_epithelium;
        v_acceptance(t) = c_acceptance;
        
        % Work out the perimeter
        [c_perimeter_approx,c_area_approx,c_area_true] = f_perimeterarea_branching_c(m_cell);
        v_perimeter(t) = c_perimeter_approx;
        
        % Work out epithelium entropy
        % First of all make all the components of the image which are not 1 zero
        c_cell_entropy = entropy(m_cell.*(m_cell==1));
        v_entropy(t) = c_cell_entropy;
        
        % Now work out the number of branchpoints
        skelImg   = bwmorph(m_cell, 'thin', 'inf');
        branchImg = bwmorph(skelImg, 'branchpoints');
        
        [row, column] = find(branchImg);
        branchPts     = [row column];
        
        cn_branch = length(branchPts);
        
        v_branch(t) = cn_branch;
        
       
        % Estimate the perimeter via edge detection
        c_perimeter_approx_new = f_perimeter_edge_approx_c(m_cell,20);
        v_perimeter_new(t) = c_perimeter_approx_new;
        
        % Get a measure of the variance in GDNF along the perimeter
        m_perimeter_GDNF = f_perimeter_GDNF_m(m_cell,m_GDNF,v_parameters);
        v_perimeter_GDNF(t) = std(m_perimeter_GDNF(:,3));
        v_perimeter_GDNF_average(t) = mean(m_perimeter_GDNF(:,3));
        
        
        
        cmap = [0 0 1; 1 1 1; 0 1 0];
        colormap(cmap);
        subplot(1,2,1),imagesc(flip(m_cell))
        title('Cell distribution','FontSize', 20)
        hold on
        % unique rectangles
        plot(rand(1, 10), 'g');
        plot(rand(1, 10), 'b');
        legend('Epithelium','Mesenchyme')
        hold off
        freezeColors
        
        subplot(1,2,2),imagesc(flip(m_GDNF))
        colormap('default')
        
        title('GDNF distribution','FontSize', 20)
        F(t) = getframe(FigHandle);
 
        writeVideo(vidObj,F(t));
        
        
        pause(0.1)
    
    
end
% vid = close(vid);
% [h, w, p] = size(F(1).cdata);  % use 1st frame to get dimensions
% hf = figure; 
% % resize figure based on frame's w x h, and place at (150, 150)
% set(hf, 'position', [150 150 w h]);
% axis off
% movie(hf,F);
% % implay(F)
% % mov = immovie(F)
close(vidObj);
