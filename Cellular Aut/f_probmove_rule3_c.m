function c_move = f_probmove_rule3_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret)
% A function which returns a 1 if a move is to occur; 0 if not. The rule
% used here is that the probability of a move is proportional to the sum of
% the local positive gradients in GDNF

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


% Get the number of moves being considered
c_nummoves = size(m_allowedindices);
c_nummoves = c_nummoves(1);

% Go through and calculate the sum of local positive gradients in GDNF
c_GDNF_gradsum = 0;

for i = 1:c_nummoves
    c_local_gradient = m_GDNF(m_allowedindices(i,1),m_allowedindices(i,2)) - m_GDNF(c_x,c_y);
    if c_local_gradient > 0
        c_GDNF_gradsum = c_GDNF_gradsum + c_local_gradient;
    end
end


% Now calculate the probability of a move probability
% Calculate the 'x' coordinate of the normal CDF
c_xnorm = c_move_norm_cons + ck_move_norm_slope*c_GDNF_gradsum;

% Calculate the probability of a move
ck_move_prob = normcdf(c_xnorm);

% Generate a random number to compare with the move probability to
% determine whether or not a move takes place
cr_a = rand();

if ck_move_prob > cr_a
    c_move = 1;
else
    c_move = 0;
end
