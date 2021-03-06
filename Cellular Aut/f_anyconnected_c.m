function c_connected = f_anyconnected_c(c_x,c_y,c_xnew,c_ynew,m_cell,v_parameters)
% A function which works out whether a move from (c_x,c_y) to
% (c_xnew,c_ynew) results in any cell in the epithelium being connected
% (c_connected = 1) or unconnected (c_connected = 0)

% Create a hypothetical copy of m_cell with the only thing being changed is
% that the cell old position is made vacant, and the new position is
% changed to 1
m_cell_copy = m_cell;
m_cell_copy(c_x,c_y) = 0;
m_cell_copy(c_xnew,c_ynew) = 1;

% Work out which cells the original cell was connected to
[cn_connections,m_connections] = f_findconnectedcomponents_m(c_x,c_y,m_cell,v_parameters);

% Work out whether any of the four possible connected neighbours become unconnected as a result of a move 
c_connectcount = 0;
for i = 1:cn_connections
    c_connectcount = c_connectcount + f_cellconnected_c(m_connections(i,1),m_connections(i,2),m_cell_copy,v_parameters);
end

if c_connectcount < cn_connections
    c_connected = 0;
else
    c_connected = 1;
end
    