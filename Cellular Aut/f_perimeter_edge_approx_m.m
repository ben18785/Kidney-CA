function m_perimeter_approx = f_perimeter_edge_approx_m(m_cell,v_parameters,c_sensitivity)
% A function which estimates the perimeter pixel ids returning them as a
% matrix of indices

% Get the edges
m_cell = m_cell.*(m_cell==1);
m_cell_edge = double(edge(m_cell));

% Remove all connected components that have a length less than 100
m_cell_edge = bwareaopen(m_cell_edge, 20);

% Find the number of cells in the perimeter
c_per_approx = sum(sum(m_cell_edge));

c_depth_full = v_parameters(6);
c_width_full = v_parameters(7);

m_perimeter_approx = zeros(c_per_approx,2);
k = 1;
% Now estimate the perimeter
for i = 1:c_depth_full
    for j = 1:c_width_full
        if m_cell_edge(i,j) == 1
            m_perimeter_approx(k,:) = [i,j];
            k = k + 1;
        end
    end
end


            