function c_move = f_mes_prob_rule1_c(c_x,c_y,m_allowedindices,v_parameters,c_cons)
% A function which calculates the probability that a move is taken, by
% assuming that it is a constant c_cons

% Generate a uniform random number on (0,1)
cr_a = rand();

c_move = 0;
if c_cons > cr_a
    c_move = 1;
end