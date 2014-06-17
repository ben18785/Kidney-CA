function m_cell = f_epithelium_ret_transform_m(c_x,c_y,m_cell,m_GDNF,v_parameters)
% A function which determines whether to transform an epithelium cell at
% (c_x,c_y) from Ret-L -> Ret-H or vice versa; dependent on the rules
% selected.

% Check that the cell passed is either a Ret-L or Ret-H epithelium
c_celltype = m_cell(c_x,c_y);
if c_celltype < 1
    'Something has gone wrong in f_epithelium_ret_transform being passed a non-epithelium cell'
end

% Now based on the rule selected, transform the cell.
c_ret_transformation = v_parameters(46);

switch c_ret_transformation
    case 0 % No transformation
        return;
    case 1 % retL -> retH arbitrary prob
        if c_celltype == 1
            c_prob_transform = v_parameters(47);
            c_transform = f_prob_arbiter_c(c_prob_transform);
        else
            return;
        end
    case 2 % Both arbitrary prob
        if c_celltype == 1
            c_prob_transform = v_parameters(47);
            c_transform = f_prob_arbiter_c(c_prob_transform); % Work out whether to tranform based on probability
        else
            c_prob_transform = v_parameters(48);
            c_transform = f_prob_arbiter_c(c_prob_transform); % Work out whether to tranform based on probability
        end
    case 3 % retL -> retH GDNF prob
        if c_celltype == 1
            c_prob_transform = f_epithelium_ret_GDNF_prob_c(c_x,c_y,m_GDNF,v_parameters,1); % Work out probability
            c_transform = f_prob_arbiter_c(c_prob_transform); % Work out whether to tranform based on probability
        else
            return;
        end
        
    case 4 % Both GDNF prob
        if c_celltype == 1
            c_prob_transform = f_epithelium_ret_GDNF_prob_c(c_x,c_y,m_GDNF,v_parameters,1); % Work out probability
            c_transform = f_prob_arbiter_c(c_prob_transform); % Work out whether to tranform based on probability
        else
            c_prob_transform = f_epithelium_ret_GDNF_prob_c(c_x,c_y,m_GDNF,v_parameters,2); % Work out probability
            c_transform = f_prob_arbiter_c(c_prob_transform); % Work out whether to tranform based on probability
        end
end

if c_transform == 0
    return;
else
    if c_celltype == 1 % If Ret-L, transform the cell to Ret-H
        m_cell(c_x,c_y) = 2;
    elseif c_celltype == 2
        m_cell(c_x,c_y) = 1;
    end
end