function [m_cell,c_move,c_heterogeneity,c_mesenchyme_options,c_vacant_select,c_mesenchyme_select,c_cell_options] = f_update_cells_m(m_cell,m_GDNF,v_parameters)
% A function which goes through and updates each of the cells in the
% simulation area in random order in accordance to rules governing their
% specific behaviour

global gc_error_count;

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
c_mesenchyme_options = 0;
c_vacant_select = 0;
c_mesenchyme_select = 0;
c_cell_options = 0;

% If we have active mesenchyme and are using a rule related to distance
% then update the cell distance matrix. Also dependent on the rule being
% used, make mesenchyme cells attracted towards Ret-high cells by
% calculating the distance matrix from these cells only
m_distance = [];
ck_ret_on = v_parameters(40);
switch ck_ret_on
    case 0 % No Ret dependence
        if and(v_parameters(33) == 1, or(v_parameters(27) == 2,v_parameters(31) == 2))
            'Distance matrix calculated'
            m_distance = f_distance_matrix_calculator_m(m_cell,v_parameters);
        end
    case 1 % Ret dependence, therefore only work out distance from the Ret-high cells
        if and(v_parameters(33) == 1, or(v_parameters(27) == 2,v_parameters(31) == 2))
            'Distance matrix calculated'
%             m_cell_rh = double(m_cell==2);
            m_distance = f_distance_matrix_calculator_m(m_cell,v_parameters);
        end
end
        

for i = 1:cn_cells
    if mod(i,1000) == 0
        m_cellindices = f_cellindices_all_m(m_cell);

        % Sort the cells into a random order
        m_cellindices = f_random_indices(m_cellindices);
    end
    
%     if m_cell(m_cellindices(i,1),m_cellindices(i,2)) ~= m_cellindices(i,3)
%         'f_update_cells: An error has been made whereby a cell has been passed to f_update_cells which has type different to what is should'
%         m_cell(m_cellindices(i,1),m_cellindices(i,2))
%         m_cellindices(i,3)
%         m_cellindices(i,1)
%         m_cellindices(i,2)
%         gc_error_count = gc_error_count + 1;
%     end
    [cell_measurables,m_cellindices] = f_update_cell_m(m_cellindices(i,:),m_cell,m_GDNF,m_distance,m_cellindices,i,v_parameters);
    m_cell = cell_measurables{1,1};
    c_hetero = c_hetero + cell_measurables{2,1};
    c_mesenchyme_options = c_mesenchyme_options + cell_measurables{3,1};
    c_move = c_move + cell_measurables{4,1};
    c_vacant_select = cell_measurables{5,1} + c_vacant_select; % The number of vacant cells selected to move/proliferate into
    c_mesenchyme_select = cell_measurables{6,1} + c_mesenchyme_select; % The number of mesenchyme cells selected to move into
    c_cell_options = c_cell_options + cell_measurables{7,1}; % The number of times that there are multiple positions available for the epithelium to move into
    
end
if gc_error_count > 0
    'An error has occurred'
end
c_heterogeneity = c_hetero/c_cell_options;