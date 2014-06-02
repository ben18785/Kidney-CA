function m_distance = f_distance_matrix_calculator_m(m_cell,v_parameters)
% A function which calculates the nearest distances of each cell from
% epithelium, returning this as a matrix of distances

% Get dimensions
c_depth_full = v_parameters(6);
c_width_full = v_parameters(7); 

% Create a distance matrix starting with values all -1
m_distance = -1*ones(c_depth_full,c_width_full);

% Find all the epithelium by first just selecting the epithelium 
m_cell_epithelium = m_cell.*(m_cell==1);
m_cellindices = f_cellindices_all_m(m_cell_epithelium);

% Get the number of cells
cn_numep = length_new(m_cellindices);

% Iterate through making all cells of the distance matrix zero when there
% are epithelium at that location
for i = 1:cn_numep
   m_distance(m_cellindices(i,1),m_cellindices(i,2)) = 0; 
end

% Now call the iterator which uses dynamic programming
m_distance = f_distance_iterator_m(m_distance,0,v_parameters);