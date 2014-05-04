function m_cellindices = f_cellindices_all_m(m_cell)
% A function which outputs the indices of all the cells in the simulation
% area, recording their type in the third column

% Get the total number of nonzero entries
cn_nonzero = sum(sum(abs(m_cell)));

% Get the full dimensions
v_dimensions_full = size(m_cell);
c_width_full = v_dimensions_full(2);
c_depth_full = v_dimensions_full(1);

% Store the results in a matrix of maximum size
m_cellindices = zeros(cn_nonzero,3);
k = 1;

for i = 1:c_depth_full
    for j = 1:c_width_full
        switch m_cell(i,j)
            case -1
                m_cellindices(k,:) = [i,j,-1];
                k = k + 1;
            case 1
                m_cellindices(k,:) = [i,j,1];
                k = k + 1;
        end
    end
end


        