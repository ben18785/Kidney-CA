function c_move = f_mes_move_prob_c(c_x,c_y,m_allowedindices,m_GDNF,m_cell,v_parameters)
% A function which determines whether or not a move of a mesenchyme at (c_x,c_y) takes place
% probabilistically; returning a 1 if it does, 0 if not. The user can
% determine the method used here via v_parameters

% Select from the parameter vector which rule to use for movement
% probabilities
ck_mes_moveprob_rule = v_parameters(27);


switch ck_mes_moveprob_rule
    case 1 % Assume probability of move is a constant
        % Get the constant
        ck_mes_moveprob_rule1_cons = v_parameters(28);
        c_move = f_mes_prob_rule1_c(c_x,c_y,m_allowedindices,v_parameters,ck_mes_moveprob_rule1_cons);
        
    case 2 % Assume probability of a move is a function of how close to the epithelium it is 
        c_move = f_mes_prob_rule2_c(c_x,c_y,m_allowedindices,m_cell,v_parameters);
        
end