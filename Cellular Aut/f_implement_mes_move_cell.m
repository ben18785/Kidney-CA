function cell_measurables = f_implement_mes_move_cell(c_move_index,m_cell,m_allowedindices,c_x,c_y,v_parameters,c_heterogeneity,cp_move_or_prolif)
% A function which implements a move or proliferation dependent on
% cp_move_or_prolif. A mesenchyme is located at (c_x,c_y).

% Check that a mesenchyme is located at (c_x,c_y)
if m_cell(c_x,c_y) ~= -1
    'An error has been made when a mesenchyme hasnt been passed to f_implement_mes_move_cell'
end

switch cp_move_or_prolif
    case 1 % Move
        m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = -1;
        m_cell(c_x,c_y) = 0;
        
    case 0 % Proliferation
        m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = -1;
end

% Store the results in a cell array
cell_measurables = cell(5,1);
cell_measurables{1,1} = m_cell;
cell_measurables{2,1} = c_heterogeneity;
cell_measurables{3,1} = 0;
cell_measurables{5,1} = 0;
cell_measurables{6,1} = 0;
cell_measurables{7,1} = 0;