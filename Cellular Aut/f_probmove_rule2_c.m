function c_move = f_probmove_rule2_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret)
% A function which returns a 1 if a move is to occur; 0 if not. The rule
% used here is that the probability of a move is proportional to the local
% level of GDNF

% Allow selection of the parameter values based on whether the cell is Ret
% low or high
switch c_ret
    case 1 % Ret low
        c_move_norm_cons = v_parameters(10);
        ck_move_norm_slope = v_parameters(11);
    case 2 % Ret high
        c_move_norm_cons = v_parameters(43);
        ck_move_norm_slope = v_parameters(44);
end
        

% Calculate the 'x' coordinate of the normal CDF
c_xnorm = c_move_norm_cons + ck_move_norm_slope*m_GDNF(c_x,c_y);

% Calculate the probability of a move
ck_move_prob = normcdf(c_xnorm);

% Generate a random number to compare with the move probability to
% determine whether or not a move takes place
cr_a = rand();

if ck_move_prob> cr_a
    c_move = 1;
else
    c_move = 0;
end


