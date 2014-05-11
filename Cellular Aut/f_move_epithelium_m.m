function [m_cell,c_move] = f_move_epithelium_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which first decides whether a move should take place (probabilistically), then if
% so, moves the cell to one of the allowed cells probabilistically.

% Determine whether or not a move takes place probabilistically.
% Allow for user to select the rule used here through v_parameters
c_move = f_probmove_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters);


% If don't move, then just return the original matrix
if c_move == 0
    m_cell = m_cell;
    return;
end

% If move is to happen, probabilistically select the move from the list of
% available moves, and return the new cell matrix
m_cell = f_pmoveselector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
