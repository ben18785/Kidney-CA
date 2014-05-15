function m_delta = f_deltas_m(c_x,c_y,m_targets)
% A function which works out the differences between the coordinates
% between (c_x,c_y) and the matrix of all possible target coordinates
% m_targets. It returns this as a matrix.

% Calculate the number of moves available to the mesenchyme
cn_mes_moves = size(m_targets);
cn_mes_moves = cn_mes_moves(1);

% Create a matrix to hold the results
m_delta = zeros(cn_mes_moves,2);

% Store the results of the deltas in a matrix
for i = 1:cn_mes_moves
   m_delta(i,:) = f_delta_v(c_x,c_y,m_targets(i,1),m_targets(i,2)); 
end