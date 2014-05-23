function c_perimeter_approx = f_perimeter_edge_approx_c(m_cell,c_sensitivity);
% A function which estimates the perimeter via edge detection.

% Get the edges
m_cell = m_cell.*(m_cell==1);
m_cell_edge = double(edge(m_cell));

% Remove all connected components that have a length less than 100
m_cell_edge = bwareaopen(m_cell_edge, 20);

% Find the number of cells in the perimeter
c_perimeter_approx = sum(sum(m_cell_edge));