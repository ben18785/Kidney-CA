function cell_measurables = f_update_cell_m(v_coords_and_type,m_cell,m_GDNF,v_parameters)
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
        cell_measurables = f_update_epithelium_m(c_x,c_y,m_cell,m_GDNF,v_parameters);
    case -1
%         c_move = 0;
%         c_heterogeneity = 0;
%         c_mesenchyme_options = 0;
%         cell_measurables{1,1} = m_cell;
%         cell_measurables{2,1} = c_heterogeneity;
%         cell_measurables{3,1} = c_mesenchyme_options;
%         cell_measurables{4,1} = c_move;
%         cell_measurables{5,1} = 0;
%         cell_measurables{6,1} = 0;
%         cell_measurables{7,1} = 0;
        cell_measurables = f_update_mesenchyme_m(c_x,c_y,m_cell,m_GDNF,[],v_parameters);
    otherwise
        'An error has occurred. A cell has been included in the cell list which is vacant'
        return;
end

