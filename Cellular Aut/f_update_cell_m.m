function [cell_measurables,m_cellindices] = f_update_cell_m(v_coords_and_type,m_cell,m_GDNF,m_distance,m_cellindices,c_indexchosen,v_parameters)
% A function which takes the coordinates and the type of cell, and updates
% the matrix of cell positions based on local movement and proliferation

% Get the x and y coordinates
c_x = v_coords_and_type(1);
c_y = v_coords_and_type(2);

% Work out cell type, and update 
c_celltype = v_coords_and_type(3);

% Create a copy for checking vs old at bottom of this file
m_cell_old = m_cell;


% Based on cell type update according to whether it is a mesenchyme or
% epithelium
switch c_celltype
    case 1
        cell_measurables = f_update_epithelium_m(c_x,c_y,m_cell,m_GDNF,v_parameters,1);
    case 2
        cell_measurables = f_update_epithelium_m(c_x,c_y,m_cell,m_GDNF,v_parameters,2);
    case -1
        if v_parameters(33) == 0 % If the mesenchyme is not being active, don't update it (computational time saver)
            c_move = 0;
            c_heterogeneity = 0;
            c_mesenchyme_options = 0;
            cell_measurables{1,1} = m_cell;
            cell_measurables{2,1} = c_heterogeneity;
            cell_measurables{3,1} = c_mesenchyme_options;
            cell_measurables{4,1} = c_move;
            cell_measurables{5,1} = 0;
            cell_measurables{6,1} = 0;
            cell_measurables{7,1} = 0;
        else % Allowing the mesenchyme to be active
            m_wnt9b = [];
            cell_measurables = f_update_mesenchyme_m(c_x,c_y,m_cell,m_GDNF,m_wnt9b,m_distance,v_parameters);
        end
    otherwise
        'An error has occurred. A cell has been included in the cell list which is vacant'
        return;
end

m_cell = cell_measurables{1,1};
% Now amending the matrix m_cellindices
if length_new(cell_measurables) > 7
    m_cell_changes = cell_measurables{8,1};
    if length_new(m_cell_changes) > 0
        m_cellindices = f_update_cellindices_m(m_cellindices,m_cell_changes,m_cell);
    end
end