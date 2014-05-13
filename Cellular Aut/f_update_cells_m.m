function [m_cell,c_move,c_heterogeneity] = f_update_cells_m(m_cell,m_GDNF,v_parameters)
% A function which goes through and updates each of the cells in the
% simulation area in random order in accordance to rules governing their
% specific behaviour


% A function which returns the indices of all non-vacant cells in the
% simulation area (so includes cells which are both mesenchyme and
% epithelium)
m_cellindices = f_cellindices_all_m(m_cell);


% Sort the cells into a random order
m_cellindices = f_random_indices(m_cellindices);

% Get the number of cells being simulated
cn_cells = size(m_cellindices);
cn_cells = cn_cells(1);

% Now update the cells in accordance to GDNF concentration, occupancy of
% adjacent cells etc
c_move = 0;
c_hetero = 0;
for i = 1:cn_cells
    [m_cell,c_move_addition,c_hetero_addition] = f_update_cell_m(m_cellindices(i,:),m_cell,m_GDNF,v_parameters);
    c_move = c_move + c_move_addition;
    c_hetero = c_hetero + c_hetero_addition;
end

c_heterogeneity = c_hetero/sum(sum(m_cell==1));