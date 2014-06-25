function cell_temp = f_mesenchyme_real_m(m_cell,c_x,c_y,c_xnew,c_ynew,c_xmes,c_ymes,m_allowed_mesenchyme_targets,v_parameters)
% A function which works out delta move associated with the epithelium, and
% then compares this delta with the change associated with all of the
% moves available to the mesenchyme. It uses a least squares measure to
% compare these, then uses a multinomial logit model to choose amongst
% these; weighing against big differences. The idea is that this should
% push the mesenchyme most often in the direction in which they are being
% pushed.


% Calculate the number of moves available to the mesenchyme
cn_mes_moves = size(m_allowed_mesenchyme_targets);
cn_mes_moves = cn_mes_moves(1);

if cn_mes_moves == 0
    'error...there are no moves available to the mesenchyme! (f_mesenchyme_real_m)'
end


% If there is only one move, make it
if cn_mes_moves == 1
    m_cell(c_xmes,c_ymes) = 0;
    m_cell(m_allowed_mesenchyme_targets(1,1),m_allowed_mesenchyme_targets(1,2)) = -1;
    cell_temp = cell(2,1);
    cell_temp{1,1} = m_cell;
    cell_temp{2,1} = [c_xmes c_ymes 0; m_allowed_mesenchyme_targets(1,1) m_allowed_mesenchyme_targets(1,2) -1];
    return;
end



% First of all calculate the delta associated with the epithelium move, and
% store the result as a vector
v_delta_epithelium_move = f_delta_v(c_x,c_y,c_xnew,c_ynew);

% Then go through and calculate the delta for each of the moves available
% to the mesenchyme
m_delta_mesenchyme = f_deltas_m(c_xmes,c_ymes,m_allowed_mesenchyme_targets);

% Now go and calculate the square 'difference' between the delta of the
% epithelium move and the moves available to the mesenchyme
v_square_difference = f_square_diff_v(v_delta_epithelium_move,m_delta_mesenchyme);

% Get the weighting against large deviations
c_beta_mesmove = v_parameters(16);


% Calculate the denominator of the multinomial logit distribution
c_denominator = 0;
for i = 1:cn_mes_moves
    c_denominator = c_denominator + exp(c_beta_mesmove*(v_square_difference(i)));
end

v_moves_prob = zeros(cn_mes_moves,1);

% Calculate the individual probabilities
for i = 1:cn_mes_moves
    v_moves_prob(i) =exp(c_beta_mesmove*(v_square_difference(i)))/c_denominator;
end
if sum(v_moves_prob) < 0.99 && sum(v_moves_prob) > 1.1
    'error'
end

% Now creating the relevant intervals in the unit interval
m_intervals = zeros(cn_mes_moves,2);
c_runninginterval = 0;
for i = 1:cn_mes_moves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + v_moves_prob(i);
    m_intervals(i,2) = c_runninginterval;
end

% Now generating the random number to then compare to the interval matrix
cr_a = rand();
c_move_index = 0;
for i = 1:cn_mes_moves
   if  cr_a > m_intervals(i,1) && cr_a < m_intervals(i,2)
       c_move_index = i;
       break;
   end
end

if c_move_index == 0
    'An error has been made where c_move_index is not assigned'
    cn_mes_moves
    v_moves_prob
    c_denominator
    c_beta_mesmove
    v_square_difference
end

% Now implementing the move
m_cell(c_xmes,c_ymes) = 0;
m_cell(m_allowed_mesenchyme_targets(c_move_index,1),m_allowed_mesenchyme_targets(c_move_index,2)) = -1;

% Store the updated cell matrix together with the indices of the moved
% mesenchyme in a cell array
cell_temp = cell(2,1);
cell_temp{1,1} = m_cell;
cell_temp{2,1} = [c_xmes c_ymes 0; m_allowed_mesenchyme_targets(c_move_index,1) m_allowed_mesenchyme_targets(c_move_index,2) -1];