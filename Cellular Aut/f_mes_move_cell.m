function cell_measurables = f_mes_move_cell(c_x,c_y,m_cell,m_GDNF,v_parameters,cp_move_or_prolif)
% A function which first decides whether to move a mesenchyme at (c_x,c_y), if it is
% decided to go through the move, then the move is implemented

% Determine whether or not a move takes place probabilistically.
% Allow for user to select the rule used here through v_parameters
[c_move,m_allowedindices] = f_prob_mes_move_c(c_x,c_y,m_GDNF,m_cell,v_parameters);

% If don't move, then just return the original matrix
if c_move == 0
    cell_measurables{1,1} = m_cell;
    cell_measurables{2,1} = 0;
    cell_measurables{3,1} = 0;
    cell_measurables{4,1} = 0;
    cell_measurables{5,1} = 0;
    cell_measurables{6,1} = 0;
    cell_measurables{7,1} = 0;
    return;
end

% If move is to happen, probabilistically select the move from the list of
% available moves, and return the new cell matrix.

% First get the rule to be used, allowing moving and proliferating to have
% different rules
switch cp_move_or_prolif
    case 1 % Move
        ck_mes_move_selector_rule = v_parameters(29);
    case 0 % Proliferation
        ck_mes_move_selector_rule = v_parameters(30);
end
        
cell_measurables = f_mes_move_selector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters,ck_mes_move_selector_rule,cp_move_or_prolif);
cell_measurables{4,1} = 0;