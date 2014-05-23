function cell_measurables = f_move_epithelium_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which first decides whether a move should take place (probabilistically), then if
% so, moves the cell to one of the allowed cells probabilistically.

% Determine whether or not a move takes place probabilistically.
% Allow for user to select the rule used here through v_parameters
c_move = f_probmove_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters);

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
% available moves, and return the new cell matrix
cell_measurables = f_pmoveselector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
cell_measurables{4,1} = c_move;