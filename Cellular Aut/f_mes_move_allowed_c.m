function [c_allowed,m_allowedindices] = f_mes_move_allowed_c(c_x,c_y,m_GDNF,m_cell,v_parameters)
% A function which determines if there are any cells available for the
% mesenchyme at (c_x,c_y) to move into, returning c_allowed = 1 if so,
% along with the list of indices.

% First get the rule that is going to be used
ck_mes_target_allowed = v_parameters(26);

switch ck_mes_target_allowed
    case 1 % Any vacant 8-NN is allowed
        m_allindices = f_allindices_8neigh_m(c_x,c_y,v_parameters);
        [c_allowed,m_allowedindices] = f_epithelium_mrule1_cm(c_x,c_y,m_allindices,m_cell,v_parameters,1);
end

        