function [m_cell] = f_create_area_m(c_width_full, c_depth_full)
% A function which creates an initial rectangular area with width (the number of cells stretching across WD at boundary)
% and a depth (number of cells of epithelium, mesenchyme and vacant)

m_cell = zeros(c_depth_full,c_width_full);