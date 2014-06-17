function c_prob_comp = f_ret_com_prob_cm(c_x,c_y,m_cell,m_GDNF,m_index_GDNF_high,v_parameters)
% A function which calculates the probability of competition occuring vs
% moving/proliferating. =

c_ret_prob_rule = v_parameters(56);

switch c_ret_prob_rule
    case 1 % The probability is a constant
        c_prob_comp = v_parameters(57);
        return;
        
    case 2 % The probability is determined endogenously through GDNF concentration
        c_ret_prob_rule2_C0 = v_parameters(58);
        c_ret_prob_rule2_C1 = v_parameters(59);
        c_GDNF_grad = m_GDNF(m_index_GDNF_high(1,1),m_index_GDNF_high(1,2)) - m_GDNF(c_x,c_y);
        
        % Check that the gradient is positive!
        if c_GDNF_grad < 0
            'An error has been made in f_ret_com_prob_cm where the GDNF gradient is negative'
            return;
        end
        c_prob_comp = normcdf(c_ret_prob_rule2_C0 + c_ret_prob_rule2_C1*c_GDNF_grad)
        return;
end
        

