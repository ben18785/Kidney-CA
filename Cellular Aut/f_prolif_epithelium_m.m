function m_cell = f_prolif_epithelium_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which first decides whether a proliferation should take place (probabilistically), then if
% so, creates a daughter cell in one of the allowed cells probabilistically.

% Determine whether or not a move takes place probabilistically.
% Allow for user to select the rule used here through v_parameters. 
c_move = f_probprolif_c(c_x,c_y,m_allowedindices,m_GDNF,v_parameters);


% If don't move, then just return the original matrix
if c_move == 0
    m_cell = m_cell;
    return;
end

% If move is to happen, probabilistically select the daughter from the list of
% available moves, and return the new cell matrix
m_cell = f_pprolifselector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);