function c_move = f_probprolif_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret)
% A function which determines whether or not a proliferation takes place
% probabilistically; returning a 1 if it does, 0 if not. The user can
% determine the method used here via v_parameters

% Select from the parameter vector which rule to use for proliferation
% probabilities
ck_prolifprob_rule = v_parameters(14);

switch ck_prolifprob_rule
    case 1 % Assume probability of proliferation is a constant
        c_move = f_probmove_rule1_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret);
        
    case 2 % Assume probability of proliferation is a function of the magnitude of the local GDNF concentration
        c_move = f_probmove_rule2_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret);
        
    case 3 % Assume probability of proliferation is a function of the sum of positive gradients of local GDNF to the allowed indices
        c_move = f_probmove_rule3_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters,c_ret);
end