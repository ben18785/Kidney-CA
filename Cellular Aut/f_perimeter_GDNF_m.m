function m_perimeter_GDNF = f_perimeter_GDNF_m(m_cell,m_GDNF,v_parameters)
% A function which returns the GDNF concentration along points which are
% estimated to be along the perimeter of the epithelium mass.

% Find the coordinates of the points which are long the perimeter of the
% mass of epithelium cells
m_perimeter_approx = f_perimeter_edge_approx_m(m_cell,v_parameters,20);

% Get number of cells along the perimeter
cn_numper = length_new(m_perimeter_approx);

% Now iterate through and get the GDNF concentration along the perimeter;
% recording both the cell indices and the GDNF concentration
m_perimeter_GDNF = zeros(cn_numper,3);
for i = 1:cn_numper
    m_perimeter_GDNF(i,:) = [m_perimeter_approx(i,:) m_GDNF(m_perimeter_approx(i,1),m_perimeter_approx(i,2))];
end
    