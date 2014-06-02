function cell_measurables = f_update_mesenchyme_m(c_x,c_y,m_cell,m_GDNF,m_wnt9b,m_distance,v_parameters)
% A function which updates the cell matrix, by applying the rules of
% movement, proliferation, differentiation and death for a mesenchyme 
% cell located at (c_x,c_y)


% Choose whether to move (1), proliferate (2), differentiate (3) (into RV)
% or die (4)
ck_mes_action = f_mesaction_selector_c(v_parameters);

switch ck_mes_action
    case 1 % Move
        cell_measurables = f_mes_move_cell(c_x,c_y,m_cell,m_GDNF,m_distance,v_parameters,1); % 1 here indicates that the action is a move
    case 2 % Proliferate
        cell_measurables = f_mes_move_cell(c_x,c_y,m_cell,m_GDNF,m_distance,v_parameters,0); % 0 here indicates that the action is a proliferation
    case 3 % Differentiate
        cell_measurables = f_mes_differentiate_cell(c_x,c_y,m_cell,m_GDNF,m_wnt9b,v_parameters);
    case 4 % Death
        cell_measurables = f_mes_death_cell(c_x,c_y,m_cell,m_GDNF,m_wnt9b,v_parameters);
end