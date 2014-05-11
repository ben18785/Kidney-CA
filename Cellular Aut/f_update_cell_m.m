function [m_cell,c_move] = f_update_cell_m(v_coords_and_type,m_cell,m_GDNF,v_parameters)
% A function which takes the coordinates and the type of cell, and updates
% the matrix of cell positions based on local movement and proliferation

% Get the x and y coordinates
c_x = v_coords_and_type(1);
c_y = v_coords_and_type(2);

% Work out cell type, and update 
c_celltype = v_coords_and_type(3);

% Based on cell type update according to whether it is a mesenchyme or
% epithelium
switch c_celltype
    case 1
        [m_cell,c_move] = f_update_epithelium_m(c_x,c_y,m_cell,m_GDNF,v_parameters);
    case -1
        c_move = 0;
%         m_cell = f_update_mesenchyme_m(c_x,c_y,m_cell,m_GDNF);
    otherwise
        'An error has occurred. A cell has been included in the cell list which is vacant'
        return;
end


