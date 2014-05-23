function cell_measurables = f_pprolif_rule7_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which chooses between the allowed movements and implements one
% of them. In this rule the probability of one particular move is equal to
% 1/#moves; ie the same across all the available moves. (c_x,c_y) is the
% current position of the epithelium cell.

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
        [~,cellm_mesenchyme_available{i,1}] = f_mesenchyme_available_cm(m_allowedindices(i,1),m_allowedindices(i,2),m_allmesenchyme,m_cell,v_parameters); % Get the indices for the allowed moves for the mesenchyme
        
            a = size(cellm_mesenchyme_available{i,1});
            a = a(1);
        if a == 0
            'No moves available in f_pprolif_rule_7_m'
        end
   end
   
end

% Check that the move does not result in a mesenchymal cell becoming
% trapped if the allowed move rule is 7.
ck_movement_rule = v_parameters(5);
c_test = 0;
if ck_movement_rule == 7
    for i = 1:cn_nummoves
        c_test = c_test + f_epithelium_engulfment_c(m_allowedindices(i,1),m_allowedindices(i,2),m_cell,v_parameters);
    end
    if c_test < cn_nummoves
        'Error has been made. A mesenchyme is trapped (f_pmoving_rule7_m)'
    end
end



% If there is only one move, make it
if cn_nummoves == 1
    c_heterogeneity = 0;
    cell_measurables = f_implement_move_cell(1,m_cell,m_allowedindices,c_x,c_y,cellm_mesenchyme_available,v_parameters,c_heterogeneity,0);
    return;
end

% The probability increment for each of the moves is thus
c_pamove = 1/cn_nummoves;

% Now creating the relevant intervals in the unit interval
m_intervals = zeros(cn_nummoves,2);
c_runninginterval = 0;
for i = 1:cn_nummoves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + c_pamove;
    m_intervals(i,2) = c_runninginterval;
end


% How much heterogeneity is there is choosing cells based on GDNF
% concentration?
v_moves_prob = zeros(cn_nummoves,1);
for i = 1:cn_nummoves
    v_moves_prob(i) = c_pamove;
end

c_hetero_numer = sum(v_moves_prob.^2)/cn_nummoves - (1/(cn_nummoves^2));
c_hetero_denom = (1/cn_nummoves) - (1/(cn_nummoves^2));
c_heterogeneity = c_hetero_numer/c_hetero_denom;


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