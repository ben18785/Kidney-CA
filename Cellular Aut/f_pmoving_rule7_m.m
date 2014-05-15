function [c_heterogeneity,m_cell] = f_pmoving_rule7_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which chooses between the allowed movements and implements one
% of them. In this rule the probability of one particular move is equal to
% 1/#moves; ie the same across all the available moves

cn_nummoves = size(m_allowedindices);
cn_nummoves = cn_nummoves(1);

% Checks if there are any mesenchymal cells in the selected bunch. If this
% is the case, then store the available cells for each of the mesenchyme to
% move into

% Create a cell array to store the possible moves for the mesenchyme
cellm_mesenchyme_available = cell(cn_nummoves,1);
for i = 1:cn_nummoves
   if m_cell(m_allowedindices(i,1),m_allowedindices(i,2)) == -1
        m_allmesenchyme = f_allindices_8neigh_m(m_allowedindices(i,1),m_allowedindices(i,2),v_parameters); % Find all possible available indices
        [~,cellm_mesenchyme_available{i,1}] = f_epithelium_mrule1_cm(m_allowedindices(i,1),m_allowedindices(i,2),m_allmesenchyme,m_cell,v_parameters); % Get the indices for the allowed moves for the mesenchyme
   end
   
end


% If there is only one move, make it
if cn_nummoves == 1
    c_heterogeneity = 0;
    if m_cell(m_allowedindices(1,1),m_allowedindices(1,2)) ~= -1
        m_cell(c_x,c_y) = 0;
        m_cell(m_allowedindices(1,1),m_allowedindices(1,2)) = 1;
        return;
    else
        m_cell = f_mesenchyme_target_choice_m(m_cell,c_x,c_y,m_allowedindices(1,1),m_allowedindices(1,2),m_allowedindices(1,1),m_allowedindices(1,2),cellm_mesenchyme_available{1},v_parameters);
        m_cell(c_x,c_y) = 0;
        m_cell(m_allowedindices(1,1),m_allowedindices(1,2)) = 1;
        return;
    end
end

% The probability increment for each of the moves is thus
c_pamove = 1/cn_nummoves;

% How much heterogeneity is there is choosing cells based on GDNF
% concentration?
v_moves_prob = zeros(cn_nummoves,1);
for i = 1:cn_nummoves
    v_moves_prob(i) = c_pamove;
end

c_hetero_numer = sum(v_moves_prob.^2)/cn_nummoves - (1/(cn_nummoves^2));
c_hetero_denom = (1/cn_nummoves) - (1/(cn_nummoves^2));
c_heterogeneity = c_hetero_numer/c_hetero_denom;


% Now creating the relevant intervals in the unit interval
m_intervals = zeros(cn_nummoves,2);
c_runninginterval = 0;
for i = 1:cn_nummoves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + c_pamove;
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
if m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) ~= -1
        m_cell(c_x,c_y) = 0;
        m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = 1;
        return;
else % If mesenchyme
        m_cell = f_mesenchyme_target_choice_m(m_cell,c_x,c_y,m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2),m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2),cellm_mesenchyme_available{c_move_index},v_parameters);
        m_cell(c_x,c_y) = 0;
        m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = 1;
        return;
end