function c_connected = f_activeconnected_c(c_x,c_y,c_xnew,c_ynew,m_cell,v_parameters)
% A function which works out whether a move from (c_x,c_y) to
% (c_xnew,c_ynew) results in the active epithelium being connected
% (c_connected = 1) or unconnected (c_connected = 0)

% Create a hypothetical copy of m_cell with the only thing being changed is
% that the cell old position is made vacant, and the new position is
% changed to 1
m_cell_copy = m_cell;
m_cell_copy(c_x,c_y) = 0;
m_cell_copy(c_xnew,c_ynew) = 1;

% Work out whether the active cell is connected in the hypothetical state
% of the world
c_connected = f_cellconnected_c(c_xnew,c_ynew,m_cell_copy,v_parameters);

