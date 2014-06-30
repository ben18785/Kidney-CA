function cell_measurables = f_ret_comp_swap(c_x,c_y,m_index_GDNF_high,m_cell,m_GDNF,v_parameters)
% A function which takes the 

% First get the probability of a competition occurs
c_prob = f_ret_com_prob_cm(c_x,c_y,m_cell,m_GDNF,m_index_GDNF_high,v_parameters);

% Now check whether the swap actually takes place
c_swap = f_prob_arbiter_c(c_prob);

if c_swap > 0
    m_cell(c_x,c_y) = 1;
    m_cell(m_index_GDNF_high(1,1),m_index_GDNF_high(1,2)) = 2;
end

cell_measurables = cell(8,1);
cell_measurables{1,1} = m_cell;
cell_measurables{2,1} = 0;
cell_measurables{3,1} = 0;
cell_measurables{4,1} = 0;
cell_measurables{5,1} = 0;
cell_measurables{6,1} = 0;
cell_measurables{7,1} = 0;
cell_measurables{8,1} = [];
return;