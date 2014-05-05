function c_move = f_probmove_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which determines whether or not a move takes place
% probabilistically; returning a 1 if it does, 0 if not. The user can
% determine the method used here via v_parameters

% Select from the parameter vector which rule to use for movement
% probabilities
ck_moveprob_rule = v_parameters(8);

switch ck_moveprob_rule
    case 1 % Assume probability of move is a constant
        c_move = f_probmove_rule1_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
        
    case 2 % Assume probability of a move is a function of the magnitude of the local GDNF concentration
        c_move = f_probmove_rule2_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
        
    case 3 % Assume probability of a move is a function of the sum of positive gradients of local GDNF to the allowed indices
        c_move = f_probmove_rule3_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
end