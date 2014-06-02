function c_move = f_mes_move_prob_c(c_x,c_y,m_allowedindices,m_GDNF,m_cell,m_distance,v_parameters,cp_move_or_prolif)
% A function which determines whether or not a move of a mesenchyme at (c_x,c_y) takes place
% probabilistically; returning a 1 if it does, 0 if not. The user can
% determine the method used here via v_parameters

% Select from the parameter vector which rule to use for movement or
% proliferation
switch cp_move_or_prolif
    case 1 % Move
        ck_mes_moveprob_rule = v_parameters(27);
        ck_mes_moveprob_rule1_cons = v_parameters(28); % If needed for rule 1
        ck_mes_moveprob_rule2_c1 = v_parameters(34); % If needed for rule 2
        ck_mes_moveprob_rule2_c2 = v_parameters(35); % If needed for rule 2
        
    case 0 % Proliferation
        ck_mes_moveprob_rule = v_parameters(31);
        ck_mes_moveprob_rule1_cons = v_parameters(32); % If needed for rule 1
        ck_mes_moveprob_rule2_c1 = v_parameters(36); % If needed for rule 2
        ck_mes_moveprob_rule2_c2 = v_parameters(37); % If needed for rule 2
end
        
% Choose the rule
switch ck_mes_moveprob_rule
    case 1 % Assume probability of action is a constant
        c_move = f_mes_prob_rule1_c(c_x,c_y,m_allowedindices,v_parameters,ck_mes_moveprob_rule1_cons);
        
    case 2 % Assume probability of action is a function of how close to the epithelium it is
        c_move = f_mes_prob_rule2_c(c_x,c_y,m_allowedindices,m_cell,m_distance,v_parameters,ck_mes_moveprob_rule2_c1,ck_mes_moveprob_rule2_c2);
        
end