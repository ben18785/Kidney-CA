function cell_measurables = f_pprolif_rule4_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which chooses between the allowed movements and implements one
% of them. In this rule the probability of one particular move is related
% to the percentage change of GDNF for that particular move. Here
% we allow movement into a mesenchyme spot; moving the mesenchyme to one of
% their available spaces


cn_nummoves = size(m_allowedindices);
cn_nummoves = cn_nummoves(1);

% Checks if there are any mesenchymal cells in the selected bunch. If this
% is the case, then store the available cells for each of the mesenchyme to
% move into

% Create a cell array to store the possible moves for the mesenchyme
cellm_mesenchyme_available = cell(cn_nummoves,1);
for i = 1:cn_nummoves
   if m_cell(m_allowedindices(i,1),m_allowedindices(i,2)) == -1
        m_allmesenchyme = f_mesenchyme_vicinity_selector_m(c_x,c_y,m_allowedindices(i,1),m_allowedindices(i,2),m_cell,v_parameters);
        [~,cellm_mesenchyme_available{i,1}] = f_epithelium_mrule1_cm(m_allowedindices(i,1),m_allowedindices(i,2),m_allmesenchyme,m_cell,v_parameters); % Get the indices for the allowed moves for the mesenchyme
   end
   
end


% If there is only one move, make it
if cn_nummoves == 1
    c_heterogeneity = 0;
    cell_measurables = f_implement_move_cell(1,m_cell,m_allowedindices,c_x,c_y,cellm_mesenchyme_available,v_parameters,c_heterogeneity,0);
    return;
end


% Getting the parameters controlling the magnitude of the strength of the
% effect of gradients of GDNF on the probability of a particular move
c_pmove_grad = v_parameters(13);

% Calculating a parameter on (0,1) which relates probability of a move to
% the magnitude of the gradient in GDNF. Making this a row vector so that
% it can be input straight away to the Dirichlet random number generator
v_moves_param = zeros(1,cn_nummoves);

for i = 1:cn_nummoves
    v_moves_param(i) = normcdf(c_pmove_grad*((m_GDNF(m_allowedindices(i,1),m_allowedindices(i,2)) - m_GDNF(c_x,c_y)))/m_GDNF(c_x,c_y));
end

% Calculating probabilities which sum to 1 using a Dirichlet distribution
v_moves_prob = drchrnd(v_moves_param,1);

% How much heterogeneity is there is choosing cells based on GDNF
% concentration?
c_hetero_numer = sum(v_moves_prob.^2)/cn_nummoves - (1/(cn_nummoves^2));
c_hetero_denom = (1/cn_nummoves) - (1/(cn_nummoves^2));
c_heterogeneity = c_hetero_numer/c_hetero_denom;

% Now creating intervals for the probabities in order to compare a random
% number and select finally the move
m_intervals = zeros(cn_nummoves,2);
c_runninginterval = 0;
for i = 1:cn_nummoves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + v_moves_prob(i);
    m_intervals(i,2) = c_runninginterval;
end


% Now generating the random number to then compare to the interval matrix
cr_a = rand();

for i = 1:cn_nummoves
   if  cr_a > m_intervals(i,1) && cr_a < m_intervals(i,2)
       c_move_index = i;
       break;
   end
end

% Now implementing the move
cell_measurables = f_implement_move_cell(c_move_index,m_cell,m_allowedindices,c_x,c_y,cellm_mesenchyme_available,v_parameters,c_heterogeneity,0);