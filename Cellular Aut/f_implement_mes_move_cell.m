function cell_measurables = f_implement_mes_move_cell(c_move_index,m_cell,m_allowedindices,c_x,c_y,v_parameters,c_heterogeneity,cp_move_or_prolif)
% A function which implements a move or proliferation dependent on
% cp_move_or_prolif. A mesenchyme is located at (c_x,c_y).


switch cp_move_or_prolif
    case 1 % Move
        m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = -1;
        m_cell(c_x,c_y) = 0;
        
    case 0 % Proliferation
        m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = -1;
end

% Store the results in a cell array
cell_measurables = cell(8,1);
cell_measurables{1,1} = m_cell;
cell_measurables{2,1} = c_heterogeneity;
cell_measurables{3,1} = 0;
cell_measurables{5,1} = 0;
cell_measurables{6,1} = 0;
cell_measurables{7,1} = 0;

% Store the old and new coordinates of the mesenchyme to allow
% m_cellindices to be updated in f_update_cells
cell_measurables{8,1} = [c_x c_y m_cell(c_x,c_y); m_allowedindices(c_move_index,1) m_allowedindices(c_move_index,2) m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2))];