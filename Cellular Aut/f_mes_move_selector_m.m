function cell_measurables = f_mes_move_selector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters,ck_mes_move_selector_rule,cp_move_or_prolif)
% A function which selects the target cell from a list of cells to be moved
% and carries out the move. It allows for both proliferations and moves by
% the parameter cp_move_or_prolif.

switch ck_mes_move_selector_rule
    case 1 % All targets are uniformly likely to be chosen
        cell_measurables = f_mes_move_selector_rule1_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters,cp_move_or_prolif);
    case 2 % Targets are weighted by the distance of the cell from the nearest epithelium
        cell_measurables = f_mes_move_selector_rule2_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters,cp_move_or_prolif);
end

