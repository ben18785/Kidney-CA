function c_move = f_probmove_rule1_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret)
% A function which returns a 1 if a move is to occur; 0 if not. The rule
% used here is that the probability of a move is a constant given in
% v_parameters(9)

% Get the move probability from the vector v_parameters dependent on
% whether the cell is Ret low or high
switch c_ret
    case 1 % Ret low
        ck_move_cons = v_parameters(9);
    case 2 % Ret high
        ck_move_cons = v_parameters(42);
end

% Generate a random number to compare with the move probability to
% determine whether or not a move takes place
cr_a = rand();

if ck_move_cons > cr_a
    c_move = 1;
else
    c_move = 0;
end



