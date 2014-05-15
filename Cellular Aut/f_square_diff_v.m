function v_square_difference = f_square_diff_v(v_delta,m_delta)
% A function which works out the square difference between two sets of
% coordinates, and returns the result as a vector.

% Calculate the number of moves available to the mesenchyme
cn_mes_moves = size(m_delta);
cn_mes_moves = cn_mes_moves(1);

v_square_difference = zeros(cn_mes_moves,1);

% Loop through calculating the square differences
for i = 1:cn_mes_moves
   v_square_difference(i) = f_square_diff_c(v_delta,m_delta(i,:)); 
end